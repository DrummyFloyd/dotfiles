#!/usr/bin/python
# -*- coding: utf-8 -*-

DOCUMENTATION = r"""
module: vfio_iommu_facts
short_description: Report PCI devices, IOMMU groups and passthrough viability
description:
  - Reads C(/sys/bus/pci/devices) and C(/sys/kernel/iommu_groups) without
    changing anything on the host.
  - For every requested passthrough device, lists the other endpoints sharing
    its IOMMU group. PCI bridges are ignored, every other device in the group
    must be passed through as well.
options:
  passthrough_devices:
    description: PCI addresses meant for passthrough (C(0000:01:00.0) or C(01:00.0)).
    type: list
    elements: str
    default: []
"""

import os
import shlex

from ansible.module_utils.basic import AnsibleModule

PCI_ROOT = "/sys/bus/pci/devices"
IOMMU_ROOT = "/sys/kernel/iommu_groups"
PCI_BRIDGE_CLASS = "0604"
CANDIDATE_CLASSES = {"03": "gpu", "0c0330": "usb_xhci"}


def read(path):
    with open(path) as f:
        return f.read().strip()


def normalize(address):
    return address if address.count(":") == 2 else "0000:" + address


def lspci_names(module):
    lspci = module.get_bin_path("lspci")
    if not lspci:
        return {}
    rc, out, _ = module.run_command([lspci, "-Dmm"])
    if rc != 0:
        return {}
    names = {}
    for line in out.splitlines():
        fields = shlex.split(line)
        if len(fields) >= 4:
            names[fields[0]] = "%s %s" % (fields[2], fields[3])
    return names


def cpu_virtualization():
    flags = set()
    with open("/proc/cpuinfo") as f:
        for line in f:
            if line.startswith("flags"):
                flags.update(line.split(":", 1)[1].split())
                break
    for flag in ("vmx", "svm"):
        if flag in flags:
            return flag
    return None


def main():
    module = AnsibleModule(
        argument_spec=dict(
            passthrough_devices=dict(type="list", elements="str", default=[]),
        ),
        supports_check_mode=True,
    )

    names = lspci_names(module)
    devices = {}
    for address in sorted(os.listdir(PCI_ROOT)):
        path = os.path.join(PCI_ROOT, address)
        group_link = os.path.join(path, "iommu_group")
        driver_link = os.path.join(path, "driver")
        devices[address] = dict(
            address=address,
            pci_class=read(os.path.join(path, "class"))[2:],
            vendor_id=read(os.path.join(path, "vendor"))[2:],
            device_id=read(os.path.join(path, "device"))[2:],
            driver=os.path.basename(os.readlink(driver_link)) if os.path.islink(driver_link) else None,
            iommu_group=os.path.basename(os.readlink(group_link)) if os.path.islink(group_link) else None,
            name=names.get(address, ""),
        )

    groups = {}
    for device in devices.values():
        if device["iommu_group"] is not None:
            groups.setdefault(device["iommu_group"], []).append(device["address"])

    requested = [normalize(a) for a in module.params["passthrough_devices"]]
    missing = [a for a in requested if a not in devices]
    conflicts = []
    for address in requested:
        group = devices.get(address, {}).get("iommu_group")
        if group is None:
            continue
        blocking = [
            member for member in groups[group]
            if member not in requested
            and not devices[member]["pci_class"].startswith(PCI_BRIDGE_CLASS)
        ]
        if blocking:
            conflicts.append(dict(device=address, iommu_group=group, blocking=blocking))

    # GPUs and xHCI controllers are the usual passthrough targets; a candidate
    # is isolated when its group only holds bridges and its own functions.
    candidates = []
    for device in devices.values():
        kind = CANDIDATE_CLASSES.get(device["pci_class"][:2]) or CANDIDATE_CLASSES.get(device["pci_class"])
        if kind is None or device["iommu_group"] is None:
            continue
        slot = device["address"].rsplit(".", 1)[0]
        endpoints = [
            member for member in groups[device["iommu_group"]]
            if not devices[member]["pci_class"].startswith(PCI_BRIDGE_CLASS)
        ]
        candidates.append(dict(
            device,
            kind=kind,
            group_endpoints=endpoints,
            isolated=all(member.startswith(slot + ".") for member in endpoints),
        ))

    module.exit_json(
        changed=False,
        passthrough_candidates=candidates,
        iommu_enabled=bool(groups),
        cpu_virtualization=cpu_virtualization(),
        pci_devices=list(devices.values()),
        iommu_groups=groups,
        passthrough_devices=requested,
        missing_devices=missing,
        group_conflicts=conflicts,
    )


if __name__ == "__main__":
    main()
