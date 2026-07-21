// GENERATED CODE - DO NOT MODIFY BY HAND.
// Run: dart run tool/generate_cluster_catalog.dart

import 'cluster_catalog.dart';

const Map<int, ClusterInfo> generatedClusterCatalog = {
  0x00000004: ClusterInfo(
    name: 'Groups',
    attributes: {
      0x00000000: AttributeInfo(
        name: 'Name Support',
        type: MatterValueType.unknown,
      ),
      0x0000FFF8: AttributeInfo(
        name: 'Generated Command List',
        type: MatterValueType.array,
      ),
      0x0000FFF9: AttributeInfo(
        name: 'Accepted Command List',
        type: MatterValueType.array,
      ),
      0x0000FFFA: AttributeInfo(
        name: 'Event List',
        type: MatterValueType.array,
      ),
      0x0000FFFC: AttributeInfo(
        name: 'Feature Map',
        type: MatterValueType.unknown,
      ),
      0x0000FFFD: AttributeInfo(
        name: 'Cluster Revision',
        type: MatterValueType.unknown,
      ),
    },
    commands: {
      0x00000000: CommandInfo(
        name: 'Add Group',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'group ID',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'group Name',
            type: MatterValueType.string,
            nullable: false,
          ),
        ],
      ),
      0x00000001: CommandInfo(
        name: 'View Group',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'group ID',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000002: CommandInfo(
        name: 'Get Group Membership',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'group List',
            type: MatterValueType.array,
            nullable: false,
          ),
        ],
      ),
      0x00000003: CommandInfo(
        name: 'Remove Group',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'group ID',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000004: CommandInfo(name: 'Remove All Groups', fields: []),
      0x00000005: CommandInfo(
        name: 'Add Group If Identifying',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'group ID',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'group Name',
            type: MatterValueType.string,
            nullable: false,
          ),
        ],
      ),
    },
  ),
  0x00000006: ClusterInfo(
    name: 'On Off',
    attributes: {
      0x00000000: AttributeInfo(name: 'On Off', type: MatterValueType.unknown),
      0x00004000: AttributeInfo(
        name: 'Global Scene Control',
        type: MatterValueType.unknown,
      ),
      0x00004001: AttributeInfo(name: 'On Time', type: MatterValueType.unknown),
      0x00004002: AttributeInfo(
        name: 'Off Wait Time',
        type: MatterValueType.unknown,
      ),
      0x00004003: AttributeInfo(
        name: 'Start Up On Off',
        type: MatterValueType.unknown,
      ),
      0x0000FFF8: AttributeInfo(
        name: 'Generated Command List',
        type: MatterValueType.array,
      ),
      0x0000FFF9: AttributeInfo(
        name: 'Accepted Command List',
        type: MatterValueType.array,
      ),
      0x0000FFFA: AttributeInfo(
        name: 'Event List',
        type: MatterValueType.array,
      ),
      0x0000FFFC: AttributeInfo(
        name: 'Feature Map',
        type: MatterValueType.unknown,
      ),
      0x0000FFFD: AttributeInfo(
        name: 'Cluster Revision',
        type: MatterValueType.unknown,
      ),
    },
    commands: {
      0x00000000: CommandInfo(name: 'Off', fields: []),
      0x00000001: CommandInfo(name: 'On', fields: []),
      0x00000002: CommandInfo(name: 'Toggle', fields: []),
      0x00000040: CommandInfo(
        name: 'Off With Effect',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'effect Identifier',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'effect Variant',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000041: CommandInfo(name: 'On With Recall Global Scene', fields: []),
      0x00000042: CommandInfo(
        name: 'On With Timed Off',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'on Off Control',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'on Time',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'off Wait Time',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
    },
  ),
  0x00000008: ClusterInfo(
    name: 'Level Control',
    attributes: {
      0x00000000: AttributeInfo(
        name: 'Current Level',
        type: MatterValueType.unknown,
      ),
      0x00000001: AttributeInfo(
        name: 'Remaining Time',
        type: MatterValueType.unknown,
      ),
      0x00000002: AttributeInfo(
        name: 'Min Level',
        type: MatterValueType.unknown,
      ),
      0x00000003: AttributeInfo(
        name: 'Max Level',
        type: MatterValueType.unknown,
      ),
      0x00000004: AttributeInfo(
        name: 'Current Frequency',
        type: MatterValueType.unknown,
      ),
      0x00000005: AttributeInfo(
        name: 'Min Frequency',
        type: MatterValueType.unknown,
      ),
      0x00000006: AttributeInfo(
        name: 'Max Frequency',
        type: MatterValueType.unknown,
      ),
      0x0000000F: AttributeInfo(name: 'Options', type: MatterValueType.unknown),
      0x00000010: AttributeInfo(
        name: 'On Off Transition Time',
        type: MatterValueType.unknown,
      ),
      0x00000011: AttributeInfo(
        name: 'On Level',
        type: MatterValueType.unknown,
      ),
      0x00000012: AttributeInfo(
        name: 'On Transition Time',
        type: MatterValueType.unknown,
      ),
      0x00000013: AttributeInfo(
        name: 'Off Transition Time',
        type: MatterValueType.unknown,
      ),
      0x00000014: AttributeInfo(
        name: 'Default Move Rate',
        type: MatterValueType.unknown,
      ),
      0x00004000: AttributeInfo(
        name: 'Start Up Current Level',
        type: MatterValueType.unknown,
      ),
      0x0000FFF8: AttributeInfo(
        name: 'Generated Command List',
        type: MatterValueType.array,
      ),
      0x0000FFF9: AttributeInfo(
        name: 'Accepted Command List',
        type: MatterValueType.array,
      ),
      0x0000FFFA: AttributeInfo(
        name: 'Event List',
        type: MatterValueType.array,
      ),
      0x0000FFFC: AttributeInfo(
        name: 'Feature Map',
        type: MatterValueType.unknown,
      ),
      0x0000FFFD: AttributeInfo(
        name: 'Cluster Revision',
        type: MatterValueType.unknown,
      ),
    },
    commands: {
      0x00000000: CommandInfo(
        name: 'Move To Level',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'level',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'transition Time',
            type: MatterValueType.unknown,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'options Mask',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'options Override',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000001: CommandInfo(
        name: 'Move',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'move Mode',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'rate',
            type: MatterValueType.unknown,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'options Mask',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'options Override',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000002: CommandInfo(
        name: 'Step',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'step Mode',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'step Size',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'transition Time',
            type: MatterValueType.unknown,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'options Mask',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 4,
            name: 'options Override',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000003: CommandInfo(
        name: 'Stop',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'options Mask',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'options Override',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000004: CommandInfo(
        name: 'Move To Level With On Off',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'level',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'transition Time',
            type: MatterValueType.unknown,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'options Mask',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'options Override',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000005: CommandInfo(
        name: 'Move With On Off',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'move Mode',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'rate',
            type: MatterValueType.unknown,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'options Mask',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'options Override',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000006: CommandInfo(
        name: 'Step With On Off',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'step Mode',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'step Size',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'transition Time',
            type: MatterValueType.unknown,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'options Mask',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 4,
            name: 'options Override',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000007: CommandInfo(
        name: 'Stop With On Off',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'options Mask',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'options Override',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000008: CommandInfo(
        name: 'Move To Closest Frequency',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'frequency',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
    },
  ),
  0x0000001D: ClusterInfo(
    name: 'Descriptor',
    attributes: {
      0x00000000: AttributeInfo(
        name: 'Device Type List',
        type: MatterValueType.array,
      ),
      0x00000001: AttributeInfo(
        name: 'Server List',
        type: MatterValueType.array,
      ),
      0x00000002: AttributeInfo(
        name: 'Client List',
        type: MatterValueType.array,
      ),
      0x00000003: AttributeInfo(
        name: 'Parts List',
        type: MatterValueType.array,
      ),
      0x00000004: AttributeInfo(name: 'Tag List', type: MatterValueType.array),
      0x0000FFF8: AttributeInfo(
        name: 'Generated Command List',
        type: MatterValueType.array,
      ),
      0x0000FFF9: AttributeInfo(
        name: 'Accepted Command List',
        type: MatterValueType.array,
      ),
      0x0000FFFA: AttributeInfo(
        name: 'Event List',
        type: MatterValueType.array,
      ),
      0x0000FFFC: AttributeInfo(
        name: 'Feature Map',
        type: MatterValueType.unknown,
      ),
      0x0000FFFD: AttributeInfo(
        name: 'Cluster Revision',
        type: MatterValueType.unknown,
      ),
    },
    commands: {},
  ),
  0x00000028: ClusterInfo(
    name: 'Basic Information',
    attributes: {
      0x00000000: AttributeInfo(
        name: 'Data Model Revision',
        type: MatterValueType.unknown,
      ),
      0x00000001: AttributeInfo(
        name: 'Vendor Name',
        type: MatterValueType.string,
      ),
      0x00000002: AttributeInfo(
        name: 'Vendor ID',
        type: MatterValueType.unknown,
      ),
      0x00000003: AttributeInfo(
        name: 'Product Name',
        type: MatterValueType.string,
      ),
      0x00000004: AttributeInfo(
        name: 'Product ID',
        type: MatterValueType.unknown,
      ),
      0x00000005: AttributeInfo(
        name: 'Node Label',
        type: MatterValueType.string,
      ),
      0x00000006: AttributeInfo(name: 'Location', type: MatterValueType.string),
      0x00000007: AttributeInfo(
        name: 'Hardware Version',
        type: MatterValueType.unknown,
      ),
      0x00000008: AttributeInfo(
        name: 'Hardware Version String',
        type: MatterValueType.string,
      ),
      0x00000009: AttributeInfo(
        name: 'Software Version',
        type: MatterValueType.unknown,
      ),
      0x0000000A: AttributeInfo(
        name: 'Software Version String',
        type: MatterValueType.string,
      ),
      0x0000000B: AttributeInfo(
        name: 'Manufacturing Date',
        type: MatterValueType.string,
      ),
      0x0000000C: AttributeInfo(
        name: 'Part Number',
        type: MatterValueType.string,
      ),
      0x0000000D: AttributeInfo(
        name: 'Product URL',
        type: MatterValueType.string,
      ),
      0x0000000E: AttributeInfo(
        name: 'Product Label',
        type: MatterValueType.string,
      ),
      0x0000000F: AttributeInfo(
        name: 'Serial Number',
        type: MatterValueType.string,
      ),
      0x00000010: AttributeInfo(
        name: 'Local Config Disabled',
        type: MatterValueType.unknown,
      ),
      0x00000011: AttributeInfo(
        name: 'Reachable',
        type: MatterValueType.unknown,
      ),
      0x00000012: AttributeInfo(
        name: 'Unique ID',
        type: MatterValueType.string,
      ),
      0x00000013: AttributeInfo(
        name: 'Capability Minima',
        type: MatterValueType.struct,
      ),
      0x00000014: AttributeInfo(
        name: 'Product Appearance',
        type: MatterValueType.struct,
      ),
      0x00000015: AttributeInfo(
        name: 'Specification Version',
        type: MatterValueType.unknown,
      ),
      0x00000016: AttributeInfo(
        name: 'Max Paths Per Invoke',
        type: MatterValueType.unknown,
      ),
      0x0000FFF8: AttributeInfo(
        name: 'Generated Command List',
        type: MatterValueType.array,
      ),
      0x0000FFF9: AttributeInfo(
        name: 'Accepted Command List',
        type: MatterValueType.array,
      ),
      0x0000FFFA: AttributeInfo(
        name: 'Event List',
        type: MatterValueType.array,
      ),
      0x0000FFFC: AttributeInfo(
        name: 'Feature Map',
        type: MatterValueType.unknown,
      ),
      0x0000FFFD: AttributeInfo(
        name: 'Cluster Revision',
        type: MatterValueType.unknown,
      ),
    },
    commands: {0x10020000: CommandInfo(name: 'Mfg Specific Ping', fields: [])},
  ),
  0x00000029: ClusterInfo(
    name: 'OTASoftware Update Provider',
    attributes: {
      0x0000FFF8: AttributeInfo(
        name: 'Generated Command List',
        type: MatterValueType.array,
      ),
      0x0000FFF9: AttributeInfo(
        name: 'Accepted Command List',
        type: MatterValueType.array,
      ),
      0x0000FFFA: AttributeInfo(
        name: 'Event List',
        type: MatterValueType.array,
      ),
      0x0000FFFC: AttributeInfo(
        name: 'Feature Map',
        type: MatterValueType.unknown,
      ),
      0x0000FFFD: AttributeInfo(
        name: 'Cluster Revision',
        type: MatterValueType.unknown,
      ),
    },
    commands: {
      0x00000000: CommandInfo(
        name: 'Query Image',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'vendor ID',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'product ID',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'software Version',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'protocols Supported',
            type: MatterValueType.array,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 4,
            name: 'hardware Version',
            type: MatterValueType.unknown,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 5,
            name: 'location',
            type: MatterValueType.string,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 6,
            name: 'requestor Can Consent',
            type: MatterValueType.unknown,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 7,
            name: 'metadata For Provider',
            type: MatterValueType.octetString,
            nullable: true,
          ),
        ],
      ),
      0x00000001: CommandInfo(
        name: 'Query Image Response',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'status',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'delayed Action Time',
            type: MatterValueType.unknown,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'image URI',
            type: MatterValueType.string,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'software Version',
            type: MatterValueType.unknown,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 4,
            name: 'software Version String',
            type: MatterValueType.string,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 5,
            name: 'update Token',
            type: MatterValueType.octetString,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 6,
            name: 'user Consent Needed',
            type: MatterValueType.unknown,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 7,
            name: 'metadata For Requestor',
            type: MatterValueType.octetString,
            nullable: true,
          ),
        ],
      ),
      0x00000002: CommandInfo(
        name: 'Apply Update Request',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'update Token',
            type: MatterValueType.octetString,
            nullable: false,
          ),
        ],
      ),
      0x00000003: CommandInfo(
        name: 'Apply Update Response',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'action',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'delayed Action Time',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000004: CommandInfo(
        name: 'Notify Update Applied',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'update Token',
            type: MatterValueType.octetString,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'software Version',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
    },
  ),
  0x0000002A: ClusterInfo(
    name: 'OTASoftware Update Requestor',
    attributes: {
      0x00000000: AttributeInfo(
        name: 'Default OTAProviders',
        type: MatterValueType.array,
      ),
      0x00000001: AttributeInfo(
        name: 'Update Possible',
        type: MatterValueType.unknown,
      ),
      0x00000002: AttributeInfo(
        name: 'Update State',
        type: MatterValueType.unknown,
      ),
      0x00000003: AttributeInfo(
        name: 'Update State Progress',
        type: MatterValueType.unknown,
      ),
      0x0000FFF8: AttributeInfo(
        name: 'Generated Command List',
        type: MatterValueType.array,
      ),
      0x0000FFF9: AttributeInfo(
        name: 'Accepted Command List',
        type: MatterValueType.array,
      ),
      0x0000FFFA: AttributeInfo(
        name: 'Event List',
        type: MatterValueType.array,
      ),
      0x0000FFFC: AttributeInfo(
        name: 'Feature Map',
        type: MatterValueType.unknown,
      ),
      0x0000FFFD: AttributeInfo(
        name: 'Cluster Revision',
        type: MatterValueType.unknown,
      ),
    },
    commands: {
      0x00000000: CommandInfo(
        name: 'Announce OTAProvider',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'provider Node ID',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'vendor ID',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'announcement Reason',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'metadata For Node',
            type: MatterValueType.octetString,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 4,
            name: 'endpoint',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
    },
  ),
  0x00000033: ClusterInfo(
    name: 'General Diagnostics',
    attributes: {
      0x00000000: AttributeInfo(
        name: 'Network Interfaces',
        type: MatterValueType.array,
      ),
      0x00000001: AttributeInfo(
        name: 'Reboot Count',
        type: MatterValueType.unknown,
      ),
      0x00000002: AttributeInfo(name: 'Up Time', type: MatterValueType.unknown),
      0x00000003: AttributeInfo(
        name: 'Total Operational Hours',
        type: MatterValueType.unknown,
      ),
      0x00000004: AttributeInfo(
        name: 'Boot Reason',
        type: MatterValueType.unknown,
      ),
      0x00000005: AttributeInfo(
        name: 'Active Hardware Faults',
        type: MatterValueType.array,
      ),
      0x00000006: AttributeInfo(
        name: 'Active Radio Faults',
        type: MatterValueType.array,
      ),
      0x00000007: AttributeInfo(
        name: 'Active Network Faults',
        type: MatterValueType.array,
      ),
      0x00000008: AttributeInfo(
        name: 'Test Event Triggers Enabled',
        type: MatterValueType.unknown,
      ),
      0x0000FFF8: AttributeInfo(
        name: 'Generated Command List',
        type: MatterValueType.array,
      ),
      0x0000FFF9: AttributeInfo(
        name: 'Accepted Command List',
        type: MatterValueType.array,
      ),
      0x0000FFFA: AttributeInfo(
        name: 'Event List',
        type: MatterValueType.array,
      ),
      0x0000FFFC: AttributeInfo(
        name: 'Feature Map',
        type: MatterValueType.unknown,
      ),
      0x0000FFFD: AttributeInfo(
        name: 'Cluster Revision',
        type: MatterValueType.unknown,
      ),
    },
    commands: {
      0x00000000: CommandInfo(
        name: 'Test Event Trigger',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'enable Key',
            type: MatterValueType.octetString,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'event Trigger',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000001: CommandInfo(name: 'Time Snapshot', fields: []),
      0x00000002: CommandInfo(
        name: 'Time Snapshot Response',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'system Time Ms',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'posix Time Ms',
            type: MatterValueType.unknown,
            nullable: true,
          ),
        ],
      ),
      0x00000003: CommandInfo(
        name: 'Payload Test Request',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'enable Key',
            type: MatterValueType.octetString,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'value',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000004: CommandInfo(
        name: 'Payload Test Response',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'payload',
            type: MatterValueType.octetString,
            nullable: false,
          ),
        ],
      ),
    },
  ),
  0x00000034: ClusterInfo(
    name: 'Software Diagnostics',
    attributes: {
      0x00000000: AttributeInfo(
        name: 'Thread Metrics',
        type: MatterValueType.array,
      ),
      0x00000001: AttributeInfo(
        name: 'Current Heap Free',
        type: MatterValueType.unknown,
      ),
      0x00000002: AttributeInfo(
        name: 'Current Heap Used',
        type: MatterValueType.unknown,
      ),
      0x00000003: AttributeInfo(
        name: 'Current Heap High Watermark',
        type: MatterValueType.unknown,
      ),
      0x0000FFF8: AttributeInfo(
        name: 'Generated Command List',
        type: MatterValueType.array,
      ),
      0x0000FFF9: AttributeInfo(
        name: 'Accepted Command List',
        type: MatterValueType.array,
      ),
      0x0000FFFA: AttributeInfo(
        name: 'Event List',
        type: MatterValueType.array,
      ),
      0x0000FFFC: AttributeInfo(
        name: 'Feature Map',
        type: MatterValueType.unknown,
      ),
      0x0000FFFD: AttributeInfo(
        name: 'Cluster Revision',
        type: MatterValueType.unknown,
      ),
    },
    commands: {0x00000000: CommandInfo(name: 'Reset Watermarks', fields: [])},
  ),
  0x00000035: ClusterInfo(
    name: 'Thread Network Diagnostics',
    attributes: {
      0x00000000: AttributeInfo(name: 'Channel', type: MatterValueType.unknown),
      0x00000001: AttributeInfo(
        name: 'Routing Role',
        type: MatterValueType.unknown,
      ),
      0x00000002: AttributeInfo(
        name: 'Network Name',
        type: MatterValueType.string,
      ),
      0x00000003: AttributeInfo(name: 'Pan Id', type: MatterValueType.unknown),
      0x00000004: AttributeInfo(
        name: 'Extended Pan Id',
        type: MatterValueType.unknown,
      ),
      0x00000005: AttributeInfo(
        name: 'Mesh Local Prefix',
        type: MatterValueType.octetString,
      ),
      0x00000006: AttributeInfo(
        name: 'Overrun Count',
        type: MatterValueType.unknown,
      ),
      0x00000007: AttributeInfo(
        name: 'Neighbor Table',
        type: MatterValueType.array,
      ),
      0x00000008: AttributeInfo(
        name: 'Route Table',
        type: MatterValueType.array,
      ),
      0x00000009: AttributeInfo(
        name: 'Partition Id',
        type: MatterValueType.unknown,
      ),
      0x0000000A: AttributeInfo(
        name: 'Weighting',
        type: MatterValueType.unknown,
      ),
      0x0000000B: AttributeInfo(
        name: 'Data Version',
        type: MatterValueType.unknown,
      ),
      0x0000000C: AttributeInfo(
        name: 'Stable Data Version',
        type: MatterValueType.unknown,
      ),
      0x0000000D: AttributeInfo(
        name: 'Leader Router Id',
        type: MatterValueType.unknown,
      ),
      0x0000000E: AttributeInfo(
        name: 'Detached Role Count',
        type: MatterValueType.unknown,
      ),
      0x0000000F: AttributeInfo(
        name: 'Child Role Count',
        type: MatterValueType.unknown,
      ),
      0x00000010: AttributeInfo(
        name: 'Router Role Count',
        type: MatterValueType.unknown,
      ),
      0x00000011: AttributeInfo(
        name: 'Leader Role Count',
        type: MatterValueType.unknown,
      ),
      0x00000012: AttributeInfo(
        name: 'Attach Attempt Count',
        type: MatterValueType.unknown,
      ),
      0x00000013: AttributeInfo(
        name: 'Partition Id Change Count',
        type: MatterValueType.unknown,
      ),
      0x00000014: AttributeInfo(
        name: 'Better Partition Attach Attempt Count',
        type: MatterValueType.unknown,
      ),
      0x00000015: AttributeInfo(
        name: 'Parent Change Count',
        type: MatterValueType.unknown,
      ),
      0x00000016: AttributeInfo(
        name: 'Tx Total Count',
        type: MatterValueType.unknown,
      ),
      0x00000017: AttributeInfo(
        name: 'Tx Unicast Count',
        type: MatterValueType.unknown,
      ),
      0x00000018: AttributeInfo(
        name: 'Tx Broadcast Count',
        type: MatterValueType.unknown,
      ),
      0x00000019: AttributeInfo(
        name: 'Tx Ack Requested Count',
        type: MatterValueType.unknown,
      ),
      0x0000001A: AttributeInfo(
        name: 'Tx Acked Count',
        type: MatterValueType.unknown,
      ),
      0x0000001B: AttributeInfo(
        name: 'Tx No Ack Requested Count',
        type: MatterValueType.unknown,
      ),
      0x0000001C: AttributeInfo(
        name: 'Tx Data Count',
        type: MatterValueType.unknown,
      ),
      0x0000001D: AttributeInfo(
        name: 'Tx Data Poll Count',
        type: MatterValueType.unknown,
      ),
      0x0000001E: AttributeInfo(
        name: 'Tx Beacon Count',
        type: MatterValueType.unknown,
      ),
      0x0000001F: AttributeInfo(
        name: 'Tx Beacon Request Count',
        type: MatterValueType.unknown,
      ),
      0x00000020: AttributeInfo(
        name: 'Tx Other Count',
        type: MatterValueType.unknown,
      ),
      0x00000021: AttributeInfo(
        name: 'Tx Retry Count',
        type: MatterValueType.unknown,
      ),
      0x00000022: AttributeInfo(
        name: 'Tx Direct Max Retry Expiry Count',
        type: MatterValueType.unknown,
      ),
      0x00000023: AttributeInfo(
        name: 'Tx Indirect Max Retry Expiry Count',
        type: MatterValueType.unknown,
      ),
      0x00000024: AttributeInfo(
        name: 'Tx Err Cca Count',
        type: MatterValueType.unknown,
      ),
      0x00000025: AttributeInfo(
        name: 'Tx Err Abort Count',
        type: MatterValueType.unknown,
      ),
      0x00000026: AttributeInfo(
        name: 'Tx Err Busy Channel Count',
        type: MatterValueType.unknown,
      ),
      0x00000027: AttributeInfo(
        name: 'Rx Total Count',
        type: MatterValueType.unknown,
      ),
      0x00000028: AttributeInfo(
        name: 'Rx Unicast Count',
        type: MatterValueType.unknown,
      ),
      0x00000029: AttributeInfo(
        name: 'Rx Broadcast Count',
        type: MatterValueType.unknown,
      ),
      0x0000002A: AttributeInfo(
        name: 'Rx Data Count',
        type: MatterValueType.unknown,
      ),
      0x0000002B: AttributeInfo(
        name: 'Rx Data Poll Count',
        type: MatterValueType.unknown,
      ),
      0x0000002C: AttributeInfo(
        name: 'Rx Beacon Count',
        type: MatterValueType.unknown,
      ),
      0x0000002D: AttributeInfo(
        name: 'Rx Beacon Request Count',
        type: MatterValueType.unknown,
      ),
      0x0000002E: AttributeInfo(
        name: 'Rx Other Count',
        type: MatterValueType.unknown,
      ),
      0x0000002F: AttributeInfo(
        name: 'Rx Address Filtered Count',
        type: MatterValueType.unknown,
      ),
      0x00000030: AttributeInfo(
        name: 'Rx Dest Addr Filtered Count',
        type: MatterValueType.unknown,
      ),
      0x00000031: AttributeInfo(
        name: 'Rx Duplicated Count',
        type: MatterValueType.unknown,
      ),
      0x00000032: AttributeInfo(
        name: 'Rx Err No Frame Count',
        type: MatterValueType.unknown,
      ),
      0x00000033: AttributeInfo(
        name: 'Rx Err Unknown Neighbor Count',
        type: MatterValueType.unknown,
      ),
      0x00000034: AttributeInfo(
        name: 'Rx Err Invalid Src Addr Count',
        type: MatterValueType.unknown,
      ),
      0x00000035: AttributeInfo(
        name: 'Rx Err Sec Count',
        type: MatterValueType.unknown,
      ),
      0x00000036: AttributeInfo(
        name: 'Rx Err Fcs Count',
        type: MatterValueType.unknown,
      ),
      0x00000037: AttributeInfo(
        name: 'Rx Err Other Count',
        type: MatterValueType.unknown,
      ),
      0x00000038: AttributeInfo(
        name: 'Active Timestamp',
        type: MatterValueType.unknown,
      ),
      0x00000039: AttributeInfo(
        name: 'Pending Timestamp',
        type: MatterValueType.unknown,
      ),
      0x0000003A: AttributeInfo(name: 'Delay', type: MatterValueType.unknown),
      0x0000003B: AttributeInfo(
        name: 'Security Policy',
        type: MatterValueType.struct,
      ),
      0x0000003C: AttributeInfo(
        name: 'Channel Page0 Mask',
        type: MatterValueType.octetString,
      ),
      0x0000003D: AttributeInfo(
        name: 'Operational Dataset Components',
        type: MatterValueType.struct,
      ),
      0x0000003E: AttributeInfo(
        name: 'Active Network Faults List',
        type: MatterValueType.array,
      ),
      0x0000FFF8: AttributeInfo(
        name: 'Generated Command List',
        type: MatterValueType.array,
      ),
      0x0000FFF9: AttributeInfo(
        name: 'Accepted Command List',
        type: MatterValueType.array,
      ),
      0x0000FFFA: AttributeInfo(
        name: 'Event List',
        type: MatterValueType.array,
      ),
      0x0000FFFC: AttributeInfo(
        name: 'Feature Map',
        type: MatterValueType.unknown,
      ),
      0x0000FFFD: AttributeInfo(
        name: 'Cluster Revision',
        type: MatterValueType.unknown,
      ),
    },
    commands: {0x00000000: CommandInfo(name: 'Reset Counts', fields: [])},
  ),
  0x00000036: ClusterInfo(
    name: 'Wi-Fi Network Diagnostics',
    attributes: {
      0x00000000: AttributeInfo(
        name: 'BSSID',
        type: MatterValueType.octetString,
      ),
      0x00000001: AttributeInfo(
        name: 'Security Type',
        type: MatterValueType.unknown,
      ),
      0x00000002: AttributeInfo(
        name: 'Wi-Fi Version',
        type: MatterValueType.unknown,
      ),
      0x00000003: AttributeInfo(
        name: 'Channel Number',
        type: MatterValueType.unknown,
      ),
      0x00000004: AttributeInfo(name: 'RSSI', type: MatterValueType.unknown),
      0x00000005: AttributeInfo(
        name: 'Beacon Lost Count',
        type: MatterValueType.unknown,
      ),
      0x00000006: AttributeInfo(
        name: 'Beacon Rx Count',
        type: MatterValueType.unknown,
      ),
      0x00000007: AttributeInfo(
        name: 'Packet Multicast Rx Count',
        type: MatterValueType.unknown,
      ),
      0x00000008: AttributeInfo(
        name: 'Packet Multicast Tx Count',
        type: MatterValueType.unknown,
      ),
      0x00000009: AttributeInfo(
        name: 'Packet Unicast Rx Count',
        type: MatterValueType.unknown,
      ),
      0x0000000A: AttributeInfo(
        name: 'Packet Unicast Tx Count',
        type: MatterValueType.unknown,
      ),
      0x0000000B: AttributeInfo(
        name: 'Current Max Rate',
        type: MatterValueType.unknown,
      ),
      0x0000000C: AttributeInfo(
        name: 'Overrun Count',
        type: MatterValueType.unknown,
      ),
      0x0000FFF8: AttributeInfo(
        name: 'Generated Command List',
        type: MatterValueType.array,
      ),
      0x0000FFF9: AttributeInfo(
        name: 'Accepted Command List',
        type: MatterValueType.array,
      ),
      0x0000FFFA: AttributeInfo(
        name: 'Event List',
        type: MatterValueType.array,
      ),
      0x0000FFFC: AttributeInfo(
        name: 'Feature Map',
        type: MatterValueType.unknown,
      ),
      0x0000FFFD: AttributeInfo(
        name: 'Cluster Revision',
        type: MatterValueType.unknown,
      ),
    },
    commands: {0x00000000: CommandInfo(name: 'Reset Counts', fields: [])},
  ),
  0x0000003C: ClusterInfo(
    name: 'Administrator Commissioning',
    attributes: {
      0x00000000: AttributeInfo(
        name: 'Window Status',
        type: MatterValueType.unknown,
      ),
      0x00000001: AttributeInfo(
        name: 'Admin Fabric Index',
        type: MatterValueType.unknown,
      ),
      0x00000002: AttributeInfo(
        name: 'Admin Vendor Id',
        type: MatterValueType.unknown,
      ),
      0x0000FFF8: AttributeInfo(
        name: 'Generated Command List',
        type: MatterValueType.array,
      ),
      0x0000FFF9: AttributeInfo(
        name: 'Accepted Command List',
        type: MatterValueType.array,
      ),
      0x0000FFFA: AttributeInfo(
        name: 'Event List',
        type: MatterValueType.array,
      ),
      0x0000FFFC: AttributeInfo(
        name: 'Feature Map',
        type: MatterValueType.unknown,
      ),
      0x0000FFFD: AttributeInfo(
        name: 'Cluster Revision',
        type: MatterValueType.unknown,
      ),
    },
    commands: {
      0x00000000: CommandInfo(
        name: 'Open Commissioning Window',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'commissioning Timeout',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'pake Passcode Verifier',
            type: MatterValueType.octetString,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'discriminator',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'iterations',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 4,
            name: 'salt',
            type: MatterValueType.octetString,
            nullable: false,
          ),
        ],
      ),
      0x00000001: CommandInfo(
        name: 'Open Basic Commissioning Window',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'commissioning Timeout',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000002: CommandInfo(name: 'Revoke Commissioning', fields: []),
    },
  ),
  0x0000003E: ClusterInfo(
    name: 'Operational Credentials',
    attributes: {
      0x00000000: AttributeInfo(name: 'NOCs', type: MatterValueType.array),
      0x00000001: AttributeInfo(name: 'Fabrics', type: MatterValueType.array),
      0x00000002: AttributeInfo(
        name: 'Supported Fabrics',
        type: MatterValueType.unknown,
      ),
      0x00000003: AttributeInfo(
        name: 'Commissioned Fabrics',
        type: MatterValueType.unknown,
      ),
      0x00000004: AttributeInfo(
        name: 'Trusted Root Certificates',
        type: MatterValueType.array,
      ),
      0x00000005: AttributeInfo(
        name: 'Current Fabric Index',
        type: MatterValueType.unknown,
      ),
      0x0000FFF8: AttributeInfo(
        name: 'Generated Command List',
        type: MatterValueType.array,
      ),
      0x0000FFF9: AttributeInfo(
        name: 'Accepted Command List',
        type: MatterValueType.array,
      ),
      0x0000FFFA: AttributeInfo(
        name: 'Event List',
        type: MatterValueType.array,
      ),
      0x0000FFFC: AttributeInfo(
        name: 'Feature Map',
        type: MatterValueType.unknown,
      ),
      0x0000FFFD: AttributeInfo(
        name: 'Cluster Revision',
        type: MatterValueType.unknown,
      ),
    },
    commands: {
      0x00000000: CommandInfo(
        name: 'Attestation Request',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'attestation Nonce',
            type: MatterValueType.octetString,
            nullable: false,
          ),
        ],
      ),
      0x00000001: CommandInfo(
        name: 'Attestation Response',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'attestation Elements',
            type: MatterValueType.octetString,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'attestation Signature',
            type: MatterValueType.octetString,
            nullable: false,
          ),
        ],
      ),
      0x00000002: CommandInfo(
        name: 'Certificate Chain Request',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'certificate Type',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000003: CommandInfo(
        name: 'Certificate Chain Response',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'certificate',
            type: MatterValueType.octetString,
            nullable: false,
          ),
        ],
      ),
      0x00000004: CommandInfo(
        name: 'CSRRequest',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'csr Nonce',
            type: MatterValueType.octetString,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'is For Update NOC',
            type: MatterValueType.unknown,
            nullable: true,
          ),
        ],
      ),
      0x00000005: CommandInfo(
        name: 'CSRResponse',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'nocsr Elements',
            type: MatterValueType.octetString,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'attestation Signature',
            type: MatterValueType.octetString,
            nullable: false,
          ),
        ],
      ),
      0x00000006: CommandInfo(
        name: 'Add NOC',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'noc Value',
            type: MatterValueType.octetString,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'icac Value',
            type: MatterValueType.octetString,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'ipk Value',
            type: MatterValueType.octetString,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'case Admin Subject',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 4,
            name: 'admin Vendor Id',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000007: CommandInfo(
        name: 'Update NOC',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'noc Value',
            type: MatterValueType.octetString,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'icac Value',
            type: MatterValueType.octetString,
            nullable: true,
          ),
        ],
      ),
      0x00000008: CommandInfo(
        name: 'NOCResponse',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'status Code',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'fabric Index',
            type: MatterValueType.unknown,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'debug Text',
            type: MatterValueType.string,
            nullable: true,
          ),
        ],
      ),
      0x00000009: CommandInfo(
        name: 'Update Fabric Label',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'label',
            type: MatterValueType.string,
            nullable: false,
          ),
        ],
      ),
      0x0000000A: CommandInfo(
        name: 'Remove Fabric',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'fabric Index',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x0000000B: CommandInfo(
        name: 'Add Trusted Root Certificate',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'root CACertificate',
            type: MatterValueType.octetString,
            nullable: false,
          ),
        ],
      ),
    },
  ),
  0x0000003F: ClusterInfo(
    name: 'Group Key Management',
    attributes: {
      0x00000000: AttributeInfo(
        name: 'Group Key Map',
        type: MatterValueType.array,
      ),
      0x00000001: AttributeInfo(
        name: 'Group Table',
        type: MatterValueType.array,
      ),
      0x00000002: AttributeInfo(
        name: 'Max Groups Per Fabric',
        type: MatterValueType.unknown,
      ),
      0x00000003: AttributeInfo(
        name: 'Max Group Keys Per Fabric',
        type: MatterValueType.unknown,
      ),
      0x0000FFF8: AttributeInfo(
        name: 'Generated Command List',
        type: MatterValueType.array,
      ),
      0x0000FFF9: AttributeInfo(
        name: 'Accepted Command List',
        type: MatterValueType.array,
      ),
      0x0000FFFA: AttributeInfo(
        name: 'Event List',
        type: MatterValueType.array,
      ),
      0x0000FFFC: AttributeInfo(
        name: 'Feature Map',
        type: MatterValueType.unknown,
      ),
      0x0000FFFD: AttributeInfo(
        name: 'Cluster Revision',
        type: MatterValueType.unknown,
      ),
    },
    commands: {
      0x00000000: CommandInfo(
        name: 'Key Set Write',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'group Key Set',
            type: MatterValueType.struct,
            nullable: false,
          ),
        ],
      ),
      0x00000001: CommandInfo(
        name: 'Key Set Read',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'group Key Set ID',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000002: CommandInfo(
        name: 'Key Set Read Response',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'group Key Set',
            type: MatterValueType.struct,
            nullable: false,
          ),
        ],
      ),
      0x00000003: CommandInfo(
        name: 'Key Set Remove',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'group Key Set ID',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000004: CommandInfo(name: 'Key Set Read All Indices', fields: []),
      0x00000005: CommandInfo(
        name: 'Key Set Read All Indices Response',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'group Key Set IDs',
            type: MatterValueType.array,
            nullable: false,
          ),
        ],
      ),
    },
  ),
  0x00000062: ClusterInfo(
    name: 'Scenes Management',
    attributes: {
      0x00000000: AttributeInfo(
        name: 'Last Configured By',
        type: MatterValueType.unknown,
      ),
      0x00000001: AttributeInfo(
        name: 'Scene Table Size',
        type: MatterValueType.unknown,
      ),
      0x00000002: AttributeInfo(
        name: 'Fabric Scene Info',
        type: MatterValueType.array,
      ),
      0x0000FFF8: AttributeInfo(
        name: 'Generated Command List',
        type: MatterValueType.array,
      ),
      0x0000FFF9: AttributeInfo(
        name: 'Accepted Command List',
        type: MatterValueType.array,
      ),
      0x0000FFFA: AttributeInfo(
        name: 'Event List',
        type: MatterValueType.array,
      ),
      0x0000FFFC: AttributeInfo(
        name: 'Feature Map',
        type: MatterValueType.unknown,
      ),
      0x0000FFFD: AttributeInfo(
        name: 'Cluster Revision',
        type: MatterValueType.unknown,
      ),
    },
    commands: {
      0x00000000: CommandInfo(
        name: 'Add Scene Response',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'status',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'group ID',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'scene ID',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000001: CommandInfo(
        name: 'View Scene Response',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'status',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'group ID',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'scene ID',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'transition Time',
            type: MatterValueType.unknown,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 4,
            name: 'scene Name',
            type: MatterValueType.string,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 5,
            name: 'extension Field Sets',
            type: MatterValueType.array,
            nullable: true,
          ),
        ],
      ),
      0x00000002: CommandInfo(
        name: 'Remove Scene Response',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'status',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'group ID',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'scene ID',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000003: CommandInfo(
        name: 'Remove All Scenes Response',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'status',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'group ID',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000004: CommandInfo(
        name: 'Store Scene Response',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'status',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'group ID',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'scene ID',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000005: CommandInfo(
        name: 'Recall Scene',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'group ID',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'scene ID',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'transition Time',
            type: MatterValueType.unknown,
            nullable: true,
          ),
        ],
      ),
      0x00000006: CommandInfo(
        name: 'Get Scene Membership Response',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'status',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'capacity',
            type: MatterValueType.unknown,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'group ID',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'scene List',
            type: MatterValueType.array,
            nullable: true,
          ),
        ],
      ),
      0x00000040: CommandInfo(
        name: 'Copy Scene Response',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'status',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'group Identifier From',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'scene Identifier From',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
    },
  ),
  0x00000101: ClusterInfo(
    name: 'Door Lock',
    attributes: {
      0x00000000: AttributeInfo(
        name: 'Lock State',
        type: MatterValueType.unknown,
      ),
      0x00000001: AttributeInfo(
        name: 'Lock Type',
        type: MatterValueType.unknown,
      ),
      0x00000002: AttributeInfo(
        name: 'Actuator Enabled',
        type: MatterValueType.unknown,
      ),
      0x00000003: AttributeInfo(
        name: 'Door State',
        type: MatterValueType.unknown,
      ),
      0x00000004: AttributeInfo(
        name: 'Door Open Events',
        type: MatterValueType.unknown,
      ),
      0x00000005: AttributeInfo(
        name: 'Door Closed Events',
        type: MatterValueType.unknown,
      ),
      0x00000006: AttributeInfo(
        name: 'Open Period',
        type: MatterValueType.unknown,
      ),
      0x00000011: AttributeInfo(
        name: 'Number Of Total Users Supported',
        type: MatterValueType.unknown,
      ),
      0x00000012: AttributeInfo(
        name: 'Number Of PINUsers Supported',
        type: MatterValueType.unknown,
      ),
      0x00000013: AttributeInfo(
        name: 'Number Of RFIDUsers Supported',
        type: MatterValueType.unknown,
      ),
      0x00000014: AttributeInfo(
        name: 'Number Of Week Day Schedules Supported Per User',
        type: MatterValueType.unknown,
      ),
      0x00000015: AttributeInfo(
        name: 'Number Of Year Day Schedules Supported Per User',
        type: MatterValueType.unknown,
      ),
      0x00000016: AttributeInfo(
        name: 'Number Of Holiday Schedules Supported',
        type: MatterValueType.unknown,
      ),
      0x00000017: AttributeInfo(
        name: 'Max PINCode Length',
        type: MatterValueType.unknown,
      ),
      0x00000018: AttributeInfo(
        name: 'Min PINCode Length',
        type: MatterValueType.unknown,
      ),
      0x00000019: AttributeInfo(
        name: 'Max RFIDCode Length',
        type: MatterValueType.unknown,
      ),
      0x0000001A: AttributeInfo(
        name: 'Min RFIDCode Length',
        type: MatterValueType.unknown,
      ),
      0x0000001B: AttributeInfo(
        name: 'Credential Rules Support',
        type: MatterValueType.unknown,
      ),
      0x0000001C: AttributeInfo(
        name: 'Number Of Credentials Supported Per User',
        type: MatterValueType.unknown,
      ),
      0x00000021: AttributeInfo(name: 'Language', type: MatterValueType.string),
      0x00000022: AttributeInfo(
        name: 'LEDSettings',
        type: MatterValueType.unknown,
      ),
      0x00000023: AttributeInfo(
        name: 'Auto Relock Time',
        type: MatterValueType.unknown,
      ),
      0x00000024: AttributeInfo(
        name: 'Sound Volume',
        type: MatterValueType.unknown,
      ),
      0x00000025: AttributeInfo(
        name: 'Operating Mode',
        type: MatterValueType.unknown,
      ),
      0x00000026: AttributeInfo(
        name: 'Supported Operating Modes',
        type: MatterValueType.unknown,
      ),
      0x00000027: AttributeInfo(
        name: 'Default Configuration Register',
        type: MatterValueType.unknown,
      ),
      0x00000028: AttributeInfo(
        name: 'Enable Local Programming',
        type: MatterValueType.unknown,
      ),
      0x00000029: AttributeInfo(
        name: 'Enable One Touch Locking',
        type: MatterValueType.unknown,
      ),
      0x0000002A: AttributeInfo(
        name: 'Enable Inside Status LED',
        type: MatterValueType.unknown,
      ),
      0x0000002B: AttributeInfo(
        name: 'Enable Privacy Mode Button',
        type: MatterValueType.unknown,
      ),
      0x0000002C: AttributeInfo(
        name: 'Local Programming Features',
        type: MatterValueType.unknown,
      ),
      0x00000030: AttributeInfo(
        name: 'Wrong Code Entry Limit',
        type: MatterValueType.unknown,
      ),
      0x00000031: AttributeInfo(
        name: 'User Code Temporary Disable Time',
        type: MatterValueType.unknown,
      ),
      0x00000032: AttributeInfo(
        name: 'Send PINOver The Air',
        type: MatterValueType.unknown,
      ),
      0x00000033: AttributeInfo(
        name: 'Require PINfor Remote Operation',
        type: MatterValueType.unknown,
      ),
      0x00000035: AttributeInfo(
        name: 'Expiring User Timeout',
        type: MatterValueType.unknown,
      ),
      0x00000080: AttributeInfo(
        name: 'Aliro Reader Verification Key',
        type: MatterValueType.octetString,
      ),
      0x00000081: AttributeInfo(
        name: 'Aliro Reader Group Identifier',
        type: MatterValueType.octetString,
      ),
      0x00000082: AttributeInfo(
        name: 'Aliro Reader Group Sub Identifier',
        type: MatterValueType.octetString,
      ),
      0x00000083: AttributeInfo(
        name: 'Aliro Expedited Transaction Supported Protocol Versions',
        type: MatterValueType.array,
      ),
      0x00000084: AttributeInfo(
        name: 'Aliro Group Resolving Key',
        type: MatterValueType.octetString,
      ),
      0x00000085: AttributeInfo(
        name: 'Aliro Supported BLEUWBProtocol Versions',
        type: MatterValueType.array,
      ),
      0x00000086: AttributeInfo(
        name: 'Aliro BLEAdvertising Version',
        type: MatterValueType.unknown,
      ),
      0x00000087: AttributeInfo(
        name: 'Number Of Aliro Credential Issuer Keys Supported',
        type: MatterValueType.unknown,
      ),
      0x00000088: AttributeInfo(
        name: 'Number Of Aliro Endpoint Keys Supported',
        type: MatterValueType.unknown,
      ),
      0x0000FFF8: AttributeInfo(
        name: 'Generated Command List',
        type: MatterValueType.array,
      ),
      0x0000FFF9: AttributeInfo(
        name: 'Accepted Command List',
        type: MatterValueType.array,
      ),
      0x0000FFFA: AttributeInfo(
        name: 'Event List',
        type: MatterValueType.array,
      ),
      0x0000FFFC: AttributeInfo(
        name: 'Feature Map',
        type: MatterValueType.unknown,
      ),
      0x0000FFFD: AttributeInfo(
        name: 'Cluster Revision',
        type: MatterValueType.unknown,
      ),
    },
    commands: {
      0x00000000: CommandInfo(
        name: 'Lock Door',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'pin Code',
            type: MatterValueType.octetString,
            nullable: true,
          ),
        ],
      ),
      0x00000001: CommandInfo(
        name: 'Unlock Door',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'pin Code',
            type: MatterValueType.octetString,
            nullable: true,
          ),
        ],
      ),
      0x00000003: CommandInfo(
        name: 'Unlock With Timeout',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'timeout',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'pin Code',
            type: MatterValueType.octetString,
            nullable: true,
          ),
        ],
      ),
      0x0000000B: CommandInfo(
        name: 'Set Week Day Schedule',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'week Day Index',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'user Index',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'days Mask',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'start Hour',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 4,
            name: 'start Minute',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 5,
            name: 'end Hour',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 6,
            name: 'end Minute',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x0000000C: CommandInfo(
        name: 'Get Week Day Schedule Response',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'week Day Index',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'user Index',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'status',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'days Mask',
            type: MatterValueType.unknown,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 4,
            name: 'start Hour',
            type: MatterValueType.unknown,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 5,
            name: 'start Minute',
            type: MatterValueType.unknown,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 6,
            name: 'end Hour',
            type: MatterValueType.unknown,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 7,
            name: 'end Minute',
            type: MatterValueType.unknown,
            nullable: true,
          ),
        ],
      ),
      0x0000000D: CommandInfo(
        name: 'Clear Week Day Schedule',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'week Day Index',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'user Index',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x0000000E: CommandInfo(
        name: 'Set Year Day Schedule',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'year Day Index',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'user Index',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'local Start Time',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'local End Time',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x0000000F: CommandInfo(
        name: 'Get Year Day Schedule Response',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'year Day Index',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'user Index',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'status',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'local Start Time',
            type: MatterValueType.unknown,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 4,
            name: 'local End Time',
            type: MatterValueType.unknown,
            nullable: true,
          ),
        ],
      ),
      0x00000010: CommandInfo(
        name: 'Clear Year Day Schedule',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'year Day Index',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'user Index',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000011: CommandInfo(
        name: 'Set Holiday Schedule',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'holiday Index',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'local Start Time',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'local End Time',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'operating Mode',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000012: CommandInfo(
        name: 'Get Holiday Schedule Response',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'holiday Index',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'status',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'local Start Time',
            type: MatterValueType.unknown,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'local End Time',
            type: MatterValueType.unknown,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 4,
            name: 'operating Mode',
            type: MatterValueType.unknown,
            nullable: true,
          ),
        ],
      ),
      0x00000013: CommandInfo(
        name: 'Clear Holiday Schedule',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'holiday Index',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x0000001A: CommandInfo(
        name: 'Set User',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'operation Type',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'user Index',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'user Name',
            type: MatterValueType.string,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'user Unique ID',
            type: MatterValueType.unknown,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 4,
            name: 'user Status',
            type: MatterValueType.unknown,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 5,
            name: 'user Type',
            type: MatterValueType.unknown,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 6,
            name: 'credential Rule',
            type: MatterValueType.unknown,
            nullable: true,
          ),
        ],
      ),
      0x0000001B: CommandInfo(
        name: 'Get User',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'user Index',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x0000001C: CommandInfo(
        name: 'Get User Response',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'user Index',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'user Name',
            type: MatterValueType.string,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'user Unique ID',
            type: MatterValueType.unknown,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'user Status',
            type: MatterValueType.unknown,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 4,
            name: 'user Type',
            type: MatterValueType.unknown,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 5,
            name: 'credential Rule',
            type: MatterValueType.unknown,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 6,
            name: 'credentials',
            type: MatterValueType.array,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 7,
            name: 'creator Fabric Index',
            type: MatterValueType.unknown,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 8,
            name: 'last Modified Fabric Index',
            type: MatterValueType.unknown,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 9,
            name: 'next User Index',
            type: MatterValueType.unknown,
            nullable: true,
          ),
        ],
      ),
      0x0000001D: CommandInfo(
        name: 'Clear User',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'user Index',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000022: CommandInfo(
        name: 'Set Credential',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'operation Type',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'credential',
            type: MatterValueType.struct,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'credential Data',
            type: MatterValueType.octetString,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'user Index',
            type: MatterValueType.unknown,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 4,
            name: 'user Status',
            type: MatterValueType.unknown,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 5,
            name: 'user Type',
            type: MatterValueType.unknown,
            nullable: true,
          ),
        ],
      ),
      0x00000023: CommandInfo(
        name: 'Set Credential Response',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'status',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'user Index',
            type: MatterValueType.unknown,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'next Credential Index',
            type: MatterValueType.unknown,
            nullable: true,
          ),
        ],
      ),
      0x00000024: CommandInfo(
        name: 'Get Credential Status',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'credential',
            type: MatterValueType.struct,
            nullable: false,
          ),
        ],
      ),
      0x00000025: CommandInfo(
        name: 'Get Credential Status Response',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'credential Exists',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'user Index',
            type: MatterValueType.unknown,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'creator Fabric Index',
            type: MatterValueType.unknown,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'last Modified Fabric Index',
            type: MatterValueType.unknown,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 4,
            name: 'next Credential Index',
            type: MatterValueType.unknown,
            nullable: true,
          ),
          CommandFieldInfo(
            tag: 5,
            name: 'credential Data',
            type: MatterValueType.octetString,
            nullable: true,
          ),
        ],
      ),
      0x00000026: CommandInfo(
        name: 'Clear Credential',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'credential',
            type: MatterValueType.struct,
            nullable: true,
          ),
        ],
      ),
      0x00000027: CommandInfo(
        name: 'Unbolt Door',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'pin Code',
            type: MatterValueType.octetString,
            nullable: true,
          ),
        ],
      ),
      0x00000028: CommandInfo(
        name: 'Set Aliro Reader Config',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'signing Key',
            type: MatterValueType.octetString,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'verification Key',
            type: MatterValueType.octetString,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'group Identifier',
            type: MatterValueType.octetString,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'group Resolving Key',
            type: MatterValueType.octetString,
            nullable: true,
          ),
        ],
      ),
      0x00000029: CommandInfo(name: 'Clear Aliro Reader Config', fields: []),
    },
  ),
  0x00000102: ClusterInfo(
    name: 'Window Covering',
    attributes: {
      0x00000000: AttributeInfo(name: 'Type', type: MatterValueType.unknown),
      0x00000001: AttributeInfo(
        name: 'Physical Closed Limit Lift',
        type: MatterValueType.unknown,
      ),
      0x00000002: AttributeInfo(
        name: 'Physical Closed Limit Tilt',
        type: MatterValueType.unknown,
      ),
      0x00000003: AttributeInfo(
        name: 'Current Position Lift',
        type: MatterValueType.unknown,
      ),
      0x00000004: AttributeInfo(
        name: 'Current Position Tilt',
        type: MatterValueType.unknown,
      ),
      0x00000005: AttributeInfo(
        name: 'Number Of Actuations Lift',
        type: MatterValueType.unknown,
      ),
      0x00000006: AttributeInfo(
        name: 'Number Of Actuations Tilt',
        type: MatterValueType.unknown,
      ),
      0x00000007: AttributeInfo(
        name: 'Config Status',
        type: MatterValueType.unknown,
      ),
      0x00000008: AttributeInfo(
        name: 'Current Position Lift Percentage',
        type: MatterValueType.unknown,
      ),
      0x00000009: AttributeInfo(
        name: 'Current Position Tilt Percentage',
        type: MatterValueType.unknown,
      ),
      0x0000000A: AttributeInfo(
        name: 'Operational Status',
        type: MatterValueType.unknown,
      ),
      0x0000000B: AttributeInfo(
        name: 'Target Position Lift Percent100ths',
        type: MatterValueType.unknown,
      ),
      0x0000000C: AttributeInfo(
        name: 'Target Position Tilt Percent100ths',
        type: MatterValueType.unknown,
      ),
      0x0000000D: AttributeInfo(
        name: 'End Product Type',
        type: MatterValueType.unknown,
      ),
      0x0000000E: AttributeInfo(
        name: 'Current Position Lift Percent100ths',
        type: MatterValueType.unknown,
      ),
      0x0000000F: AttributeInfo(
        name: 'Current Position Tilt Percent100ths',
        type: MatterValueType.unknown,
      ),
      0x00000010: AttributeInfo(
        name: 'Installed Open Limit Lift',
        type: MatterValueType.unknown,
      ),
      0x00000011: AttributeInfo(
        name: 'Installed Closed Limit Lift',
        type: MatterValueType.unknown,
      ),
      0x00000012: AttributeInfo(
        name: 'Installed Open Limit Tilt',
        type: MatterValueType.unknown,
      ),
      0x00000013: AttributeInfo(
        name: 'Installed Closed Limit Tilt',
        type: MatterValueType.unknown,
      ),
      0x00000017: AttributeInfo(name: 'Mode', type: MatterValueType.unknown),
      0x0000001A: AttributeInfo(
        name: 'Safety Status',
        type: MatterValueType.unknown,
      ),
      0x0000FFF8: AttributeInfo(
        name: 'Generated Command List',
        type: MatterValueType.array,
      ),
      0x0000FFF9: AttributeInfo(
        name: 'Accepted Command List',
        type: MatterValueType.array,
      ),
      0x0000FFFA: AttributeInfo(
        name: 'Event List',
        type: MatterValueType.array,
      ),
      0x0000FFFC: AttributeInfo(
        name: 'Feature Map',
        type: MatterValueType.unknown,
      ),
      0x0000FFFD: AttributeInfo(
        name: 'Cluster Revision',
        type: MatterValueType.unknown,
      ),
    },
    commands: {
      0x00000000: CommandInfo(name: 'Up Or Open', fields: []),
      0x00000001: CommandInfo(name: 'Down Or Close', fields: []),
      0x00000002: CommandInfo(name: 'Stop Motion', fields: []),
      0x00000004: CommandInfo(
        name: 'Go To Lift Value',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'lift Value',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000005: CommandInfo(
        name: 'Go To Lift Percentage',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'lift Percent100ths Value',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000007: CommandInfo(
        name: 'Go To Tilt Value',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'tilt Value',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000008: CommandInfo(
        name: 'Go To Tilt Percentage',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'tilt Percent100ths Value',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
    },
  ),
  0x00000201: ClusterInfo(
    name: 'Thermostat',
    attributes: {
      0x00000000: AttributeInfo(
        name: 'Local Temperature',
        type: MatterValueType.unknown,
      ),
      0x00000001: AttributeInfo(
        name: 'Outdoor Temperature',
        type: MatterValueType.unknown,
      ),
      0x00000002: AttributeInfo(
        name: 'Occupancy',
        type: MatterValueType.unknown,
      ),
      0x00000003: AttributeInfo(
        name: 'Abs Min Heat Setpoint Limit',
        type: MatterValueType.unknown,
      ),
      0x00000004: AttributeInfo(
        name: 'Abs Max Heat Setpoint Limit',
        type: MatterValueType.unknown,
      ),
      0x00000005: AttributeInfo(
        name: 'Abs Min Cool Setpoint Limit',
        type: MatterValueType.unknown,
      ),
      0x00000006: AttributeInfo(
        name: 'Abs Max Cool Setpoint Limit',
        type: MatterValueType.unknown,
      ),
      0x00000007: AttributeInfo(
        name: 'PICooling Demand',
        type: MatterValueType.unknown,
      ),
      0x00000008: AttributeInfo(
        name: 'PIHeating Demand',
        type: MatterValueType.unknown,
      ),
      0x00000009: AttributeInfo(
        name: 'HVACSystem Type Configuration',
        type: MatterValueType.unknown,
      ),
      0x00000010: AttributeInfo(
        name: 'Local Temperature Calibration',
        type: MatterValueType.unknown,
      ),
      0x00000011: AttributeInfo(
        name: 'Occupied Cooling Setpoint',
        type: MatterValueType.unknown,
      ),
      0x00000012: AttributeInfo(
        name: 'Occupied Heating Setpoint',
        type: MatterValueType.unknown,
      ),
      0x00000013: AttributeInfo(
        name: 'Unoccupied Cooling Setpoint',
        type: MatterValueType.unknown,
      ),
      0x00000014: AttributeInfo(
        name: 'Unoccupied Heating Setpoint',
        type: MatterValueType.unknown,
      ),
      0x00000015: AttributeInfo(
        name: 'Min Heat Setpoint Limit',
        type: MatterValueType.unknown,
      ),
      0x00000016: AttributeInfo(
        name: 'Max Heat Setpoint Limit',
        type: MatterValueType.unknown,
      ),
      0x00000017: AttributeInfo(
        name: 'Min Cool Setpoint Limit',
        type: MatterValueType.unknown,
      ),
      0x00000018: AttributeInfo(
        name: 'Max Cool Setpoint Limit',
        type: MatterValueType.unknown,
      ),
      0x00000019: AttributeInfo(
        name: 'Min Setpoint Dead Band',
        type: MatterValueType.unknown,
      ),
      0x0000001A: AttributeInfo(
        name: 'Remote Sensing',
        type: MatterValueType.unknown,
      ),
      0x0000001B: AttributeInfo(
        name: 'Control Sequence Of Operation',
        type: MatterValueType.unknown,
      ),
      0x0000001C: AttributeInfo(
        name: 'System Mode',
        type: MatterValueType.unknown,
      ),
      0x0000001E: AttributeInfo(
        name: 'Thermostat Running Mode',
        type: MatterValueType.unknown,
      ),
      0x00000020: AttributeInfo(
        name: 'Start Of Week',
        type: MatterValueType.unknown,
      ),
      0x00000021: AttributeInfo(
        name: 'Number Of Weekly Transitions',
        type: MatterValueType.unknown,
      ),
      0x00000022: AttributeInfo(
        name: 'Number Of Daily Transitions',
        type: MatterValueType.unknown,
      ),
      0x00000023: AttributeInfo(
        name: 'Temperature Setpoint Hold',
        type: MatterValueType.unknown,
      ),
      0x00000024: AttributeInfo(
        name: 'Temperature Setpoint Hold Duration',
        type: MatterValueType.unknown,
      ),
      0x00000025: AttributeInfo(
        name: 'Thermostat Programming Operation Mode',
        type: MatterValueType.unknown,
      ),
      0x00000029: AttributeInfo(
        name: 'Thermostat Running State',
        type: MatterValueType.unknown,
      ),
      0x00000030: AttributeInfo(
        name: 'Setpoint Change Source',
        type: MatterValueType.unknown,
      ),
      0x00000031: AttributeInfo(
        name: 'Setpoint Change Amount',
        type: MatterValueType.unknown,
      ),
      0x00000032: AttributeInfo(
        name: 'Setpoint Change Source Timestamp',
        type: MatterValueType.unknown,
      ),
      0x00000034: AttributeInfo(
        name: 'Occupied Setback',
        type: MatterValueType.unknown,
      ),
      0x00000035: AttributeInfo(
        name: 'Occupied Setback Min',
        type: MatterValueType.unknown,
      ),
      0x00000036: AttributeInfo(
        name: 'Occupied Setback Max',
        type: MatterValueType.unknown,
      ),
      0x00000037: AttributeInfo(
        name: 'Unoccupied Setback',
        type: MatterValueType.unknown,
      ),
      0x00000038: AttributeInfo(
        name: 'Unoccupied Setback Min',
        type: MatterValueType.unknown,
      ),
      0x00000039: AttributeInfo(
        name: 'Unoccupied Setback Max',
        type: MatterValueType.unknown,
      ),
      0x0000003A: AttributeInfo(
        name: 'Emergency Heat Delta',
        type: MatterValueType.unknown,
      ),
      0x00000040: AttributeInfo(name: 'ACType', type: MatterValueType.unknown),
      0x00000041: AttributeInfo(
        name: 'ACCapacity',
        type: MatterValueType.unknown,
      ),
      0x00000042: AttributeInfo(
        name: 'ACRefrigerant Type',
        type: MatterValueType.unknown,
      ),
      0x00000043: AttributeInfo(
        name: 'ACCompressor Type',
        type: MatterValueType.unknown,
      ),
      0x00000044: AttributeInfo(
        name: 'ACError Code',
        type: MatterValueType.unknown,
      ),
      0x00000045: AttributeInfo(
        name: 'ACLouver Position',
        type: MatterValueType.unknown,
      ),
      0x00000046: AttributeInfo(
        name: 'ACCoil Temperature',
        type: MatterValueType.unknown,
      ),
      0x00000047: AttributeInfo(
        name: 'ACCapacityformat',
        type: MatterValueType.unknown,
      ),
      0x00000048: AttributeInfo(
        name: 'Preset Types',
        type: MatterValueType.array,
      ),
      0x00000049: AttributeInfo(
        name: 'Schedule Types',
        type: MatterValueType.array,
      ),
      0x0000004A: AttributeInfo(
        name: 'Number Of Presets',
        type: MatterValueType.unknown,
      ),
      0x0000004B: AttributeInfo(
        name: 'Number Of Schedules',
        type: MatterValueType.unknown,
      ),
      0x0000004C: AttributeInfo(
        name: 'Number Of Schedule Transitions',
        type: MatterValueType.unknown,
      ),
      0x0000004D: AttributeInfo(
        name: 'Number Of Schedule Transition Per Day',
        type: MatterValueType.unknown,
      ),
      0x0000004E: AttributeInfo(
        name: 'Active Preset Handle',
        type: MatterValueType.octetString,
      ),
      0x0000004F: AttributeInfo(
        name: 'Active Schedule Handle',
        type: MatterValueType.octetString,
      ),
      0x00000050: AttributeInfo(name: 'Presets', type: MatterValueType.array),
      0x00000051: AttributeInfo(name: 'Schedules', type: MatterValueType.array),
      0x00000052: AttributeInfo(
        name: 'Setpoint Hold Expiry Timestamp',
        type: MatterValueType.unknown,
      ),
      0x0000FFF8: AttributeInfo(
        name: 'Generated Command List',
        type: MatterValueType.array,
      ),
      0x0000FFF9: AttributeInfo(
        name: 'Accepted Command List',
        type: MatterValueType.array,
      ),
      0x0000FFFA: AttributeInfo(
        name: 'Event List',
        type: MatterValueType.array,
      ),
      0x0000FFFC: AttributeInfo(
        name: 'Feature Map',
        type: MatterValueType.unknown,
      ),
      0x0000FFFD: AttributeInfo(
        name: 'Cluster Revision',
        type: MatterValueType.unknown,
      ),
    },
    commands: {
      0x00000000: CommandInfo(
        name: 'Get Weekly Schedule Response',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'number Of Transitions For Sequence',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'day Of Week For Sequence',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'mode For Sequence',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'transitions',
            type: MatterValueType.array,
            nullable: false,
          ),
        ],
      ),
      0x00000001: CommandInfo(
        name: 'Set Weekly Schedule',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'number Of Transitions For Sequence',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'day Of Week For Sequence',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'mode For Sequence',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'transitions',
            type: MatterValueType.array,
            nullable: false,
          ),
        ],
      ),
      0x00000002: CommandInfo(
        name: 'Get Weekly Schedule',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'days To Return',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'mode To Return',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000003: CommandInfo(name: 'Clear Weekly Schedule', fields: []),
      0x00000005: CommandInfo(
        name: 'Set Active Schedule Request',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'schedule Handle',
            type: MatterValueType.octetString,
            nullable: false,
          ),
        ],
      ),
      0x00000006: CommandInfo(
        name: 'Set Active Preset Request',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'preset Handle',
            type: MatterValueType.octetString,
            nullable: true,
          ),
        ],
      ),
      0x000000FD: CommandInfo(
        name: 'Atomic Response',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'status Code',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'attribute Status',
            type: MatterValueType.array,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'timeout',
            type: MatterValueType.unknown,
            nullable: true,
          ),
        ],
      ),
      0x000000FE: CommandInfo(
        name: 'Atomic Request',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'request Type',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'attribute Requests',
            type: MatterValueType.array,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'timeout',
            type: MatterValueType.unknown,
            nullable: true,
          ),
        ],
      ),
    },
  ),
  0x00000300: ClusterInfo(
    name: 'Color Control',
    attributes: {
      0x00000000: AttributeInfo(
        name: 'Current Hue',
        type: MatterValueType.unknown,
      ),
      0x00000001: AttributeInfo(
        name: 'Current Saturation',
        type: MatterValueType.unknown,
      ),
      0x00000002: AttributeInfo(
        name: 'Remaining Time',
        type: MatterValueType.unknown,
      ),
      0x00000003: AttributeInfo(
        name: 'Current X',
        type: MatterValueType.unknown,
      ),
      0x00000004: AttributeInfo(
        name: 'Current Y',
        type: MatterValueType.unknown,
      ),
      0x00000005: AttributeInfo(
        name: 'Drift Compensation',
        type: MatterValueType.unknown,
      ),
      0x00000006: AttributeInfo(
        name: 'Compensation Text',
        type: MatterValueType.string,
      ),
      0x00000007: AttributeInfo(
        name: 'Color Temperature Mireds',
        type: MatterValueType.unknown,
      ),
      0x00000008: AttributeInfo(
        name: 'Color Mode',
        type: MatterValueType.unknown,
      ),
      0x0000000F: AttributeInfo(name: 'Options', type: MatterValueType.unknown),
      0x00000010: AttributeInfo(
        name: 'Number Of Primaries',
        type: MatterValueType.unknown,
      ),
      0x00000011: AttributeInfo(
        name: 'Primary1 X',
        type: MatterValueType.unknown,
      ),
      0x00000012: AttributeInfo(
        name: 'Primary1 Y',
        type: MatterValueType.unknown,
      ),
      0x00000013: AttributeInfo(
        name: 'Primary1 Intensity',
        type: MatterValueType.unknown,
      ),
      0x00000015: AttributeInfo(
        name: 'Primary2 X',
        type: MatterValueType.unknown,
      ),
      0x00000016: AttributeInfo(
        name: 'Primary2 Y',
        type: MatterValueType.unknown,
      ),
      0x00000017: AttributeInfo(
        name: 'Primary2 Intensity',
        type: MatterValueType.unknown,
      ),
      0x00000019: AttributeInfo(
        name: 'Primary3 X',
        type: MatterValueType.unknown,
      ),
      0x0000001A: AttributeInfo(
        name: 'Primary3 Y',
        type: MatterValueType.unknown,
      ),
      0x0000001B: AttributeInfo(
        name: 'Primary3 Intensity',
        type: MatterValueType.unknown,
      ),
      0x00000020: AttributeInfo(
        name: 'Primary4 X',
        type: MatterValueType.unknown,
      ),
      0x00000021: AttributeInfo(
        name: 'Primary4 Y',
        type: MatterValueType.unknown,
      ),
      0x00000022: AttributeInfo(
        name: 'Primary4 Intensity',
        type: MatterValueType.unknown,
      ),
      0x00000024: AttributeInfo(
        name: 'Primary5 X',
        type: MatterValueType.unknown,
      ),
      0x00000025: AttributeInfo(
        name: 'Primary5 Y',
        type: MatterValueType.unknown,
      ),
      0x00000026: AttributeInfo(
        name: 'Primary5 Intensity',
        type: MatterValueType.unknown,
      ),
      0x00000028: AttributeInfo(
        name: 'Primary6 X',
        type: MatterValueType.unknown,
      ),
      0x00000029: AttributeInfo(
        name: 'Primary6 Y',
        type: MatterValueType.unknown,
      ),
      0x0000002A: AttributeInfo(
        name: 'Primary6 Intensity',
        type: MatterValueType.unknown,
      ),
      0x00000030: AttributeInfo(
        name: 'White Point X',
        type: MatterValueType.unknown,
      ),
      0x00000031: AttributeInfo(
        name: 'White Point Y',
        type: MatterValueType.unknown,
      ),
      0x00000032: AttributeInfo(
        name: 'Color Point RX',
        type: MatterValueType.unknown,
      ),
      0x00000033: AttributeInfo(
        name: 'Color Point RY',
        type: MatterValueType.unknown,
      ),
      0x00000034: AttributeInfo(
        name: 'Color Point RIntensity',
        type: MatterValueType.unknown,
      ),
      0x00000036: AttributeInfo(
        name: 'Color Point GX',
        type: MatterValueType.unknown,
      ),
      0x00000037: AttributeInfo(
        name: 'Color Point GY',
        type: MatterValueType.unknown,
      ),
      0x00000038: AttributeInfo(
        name: 'Color Point GIntensity',
        type: MatterValueType.unknown,
      ),
      0x0000003A: AttributeInfo(
        name: 'Color Point BX',
        type: MatterValueType.unknown,
      ),
      0x0000003B: AttributeInfo(
        name: 'Color Point BY',
        type: MatterValueType.unknown,
      ),
      0x0000003C: AttributeInfo(
        name: 'Color Point BIntensity',
        type: MatterValueType.unknown,
      ),
      0x00004000: AttributeInfo(
        name: 'Enhanced Current Hue',
        type: MatterValueType.unknown,
      ),
      0x00004001: AttributeInfo(
        name: 'Enhanced Color Mode',
        type: MatterValueType.unknown,
      ),
      0x00004002: AttributeInfo(
        name: 'Color Loop Active',
        type: MatterValueType.unknown,
      ),
      0x00004003: AttributeInfo(
        name: 'Color Loop Direction',
        type: MatterValueType.unknown,
      ),
      0x00004004: AttributeInfo(
        name: 'Color Loop Time',
        type: MatterValueType.unknown,
      ),
      0x00004005: AttributeInfo(
        name: 'Color Loop Start Enhanced Hue',
        type: MatterValueType.unknown,
      ),
      0x00004006: AttributeInfo(
        name: 'Color Loop Stored Enhanced Hue',
        type: MatterValueType.unknown,
      ),
      0x0000400A: AttributeInfo(
        name: 'Color Capabilities',
        type: MatterValueType.unknown,
      ),
      0x0000400B: AttributeInfo(
        name: 'Color Temp Physical Min Mireds',
        type: MatterValueType.unknown,
      ),
      0x0000400C: AttributeInfo(
        name: 'Color Temp Physical Max Mireds',
        type: MatterValueType.unknown,
      ),
      0x0000400D: AttributeInfo(
        name: 'Couple Color Temp To Level Min Mireds',
        type: MatterValueType.unknown,
      ),
      0x00004010: AttributeInfo(
        name: 'Start Up Color Temperature Mireds',
        type: MatterValueType.unknown,
      ),
      0x0000FFF8: AttributeInfo(
        name: 'Generated Command List',
        type: MatterValueType.array,
      ),
      0x0000FFF9: AttributeInfo(
        name: 'Accepted Command List',
        type: MatterValueType.array,
      ),
      0x0000FFFA: AttributeInfo(
        name: 'Event List',
        type: MatterValueType.array,
      ),
      0x0000FFFC: AttributeInfo(
        name: 'Feature Map',
        type: MatterValueType.unknown,
      ),
      0x0000FFFD: AttributeInfo(
        name: 'Cluster Revision',
        type: MatterValueType.unknown,
      ),
    },
    commands: {
      0x00000000: CommandInfo(
        name: 'Move To Hue',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'hue',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'direction',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'transition Time',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'options Mask',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 4,
            name: 'options Override',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000001: CommandInfo(
        name: 'Move Hue',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'move Mode',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'rate',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'options Mask',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'options Override',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000002: CommandInfo(
        name: 'Step Hue',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'step Mode',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'step Size',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'transition Time',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'options Mask',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 4,
            name: 'options Override',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000003: CommandInfo(
        name: 'Move To Saturation',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'saturation',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'transition Time',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'options Mask',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'options Override',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000004: CommandInfo(
        name: 'Move Saturation',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'move Mode',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'rate',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'options Mask',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'options Override',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000005: CommandInfo(
        name: 'Step Saturation',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'step Mode',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'step Size',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'transition Time',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'options Mask',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 4,
            name: 'options Override',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000006: CommandInfo(
        name: 'Move To Hue And Saturation',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'hue',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'saturation',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'transition Time',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'options Mask',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 4,
            name: 'options Override',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000007: CommandInfo(
        name: 'Move To Color',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'color X',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'color Y',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'transition Time',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'options Mask',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 4,
            name: 'options Override',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000008: CommandInfo(
        name: 'Move Color',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'rate X',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'rate Y',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'options Mask',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'options Override',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000009: CommandInfo(
        name: 'Step Color',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'step X',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'step Y',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'transition Time',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'options Mask',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 4,
            name: 'options Override',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x0000000A: CommandInfo(
        name: 'Move To Color Temperature',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'color Temperature Mireds',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'transition Time',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'options Mask',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'options Override',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000040: CommandInfo(
        name: 'Enhanced Move To Hue',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'enhanced Hue',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'direction',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'transition Time',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'options Mask',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 4,
            name: 'options Override',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000041: CommandInfo(
        name: 'Enhanced Move Hue',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'move Mode',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'rate',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'options Mask',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'options Override',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000042: CommandInfo(
        name: 'Enhanced Step Hue',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'step Mode',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'step Size',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'transition Time',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'options Mask',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 4,
            name: 'options Override',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000043: CommandInfo(
        name: 'Enhanced Move To Hue And Saturation',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'enhanced Hue',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'saturation',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'transition Time',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'options Mask',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 4,
            name: 'options Override',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000044: CommandInfo(
        name: 'Color Loop Set',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'update Flags',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'action',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'direction',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'time',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 4,
            name: 'start Hue',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 5,
            name: 'options Mask',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 6,
            name: 'options Override',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x00000047: CommandInfo(
        name: 'Stop Move Step',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'options Mask',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'options Override',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x0000004B: CommandInfo(
        name: 'Move Color Temperature',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'move Mode',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'rate',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'color Temperature Minimum Mireds',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'color Temperature Maximum Mireds',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 4,
            name: 'options Mask',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 5,
            name: 'options Override',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
      0x0000004C: CommandInfo(
        name: 'Step Color Temperature',
        fields: [
          CommandFieldInfo(
            tag: 0,
            name: 'step Mode',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 1,
            name: 'step Size',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 2,
            name: 'transition Time',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 3,
            name: 'color Temperature Minimum Mireds',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 4,
            name: 'color Temperature Maximum Mireds',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 5,
            name: 'options Mask',
            type: MatterValueType.unknown,
            nullable: false,
          ),
          CommandFieldInfo(
            tag: 6,
            name: 'options Override',
            type: MatterValueType.unknown,
            nullable: false,
          ),
        ],
      ),
    },
  ),
  0x00000400: ClusterInfo(
    name: 'Illuminance Measurement',
    attributes: {
      0x00000000: AttributeInfo(
        name: 'Measured Value',
        type: MatterValueType.unknown,
      ),
      0x00000001: AttributeInfo(
        name: 'Min Measured Value',
        type: MatterValueType.unknown,
      ),
      0x00000002: AttributeInfo(
        name: 'Max Measured Value',
        type: MatterValueType.unknown,
      ),
      0x00000003: AttributeInfo(
        name: 'Tolerance',
        type: MatterValueType.unknown,
      ),
      0x00000004: AttributeInfo(
        name: 'Light Sensor Type',
        type: MatterValueType.unknown,
      ),
      0x0000FFF8: AttributeInfo(
        name: 'Generated Command List',
        type: MatterValueType.array,
      ),
      0x0000FFF9: AttributeInfo(
        name: 'Accepted Command List',
        type: MatterValueType.array,
      ),
      0x0000FFFA: AttributeInfo(
        name: 'Event List',
        type: MatterValueType.array,
      ),
      0x0000FFFC: AttributeInfo(
        name: 'Feature Map',
        type: MatterValueType.unknown,
      ),
      0x0000FFFD: AttributeInfo(
        name: 'Cluster Revision',
        type: MatterValueType.unknown,
      ),
    },
    commands: {},
  ),
  0x00000402: ClusterInfo(
    name: 'Temperature Measurement',
    attributes: {
      0x00000000: AttributeInfo(
        name: 'Measured Value',
        type: MatterValueType.unknown,
      ),
      0x00000001: AttributeInfo(
        name: 'Min Measured Value',
        type: MatterValueType.unknown,
      ),
      0x00000002: AttributeInfo(
        name: 'Max Measured Value',
        type: MatterValueType.unknown,
      ),
      0x00000003: AttributeInfo(
        name: 'Tolerance',
        type: MatterValueType.unknown,
      ),
      0x0000FFF8: AttributeInfo(
        name: 'Generated Command List',
        type: MatterValueType.array,
      ),
      0x0000FFF9: AttributeInfo(
        name: 'Accepted Command List',
        type: MatterValueType.array,
      ),
      0x0000FFFA: AttributeInfo(
        name: 'Event List',
        type: MatterValueType.array,
      ),
      0x0000FFFC: AttributeInfo(
        name: 'Feature Map',
        type: MatterValueType.unknown,
      ),
      0x0000FFFD: AttributeInfo(
        name: 'Cluster Revision',
        type: MatterValueType.unknown,
      ),
    },
    commands: {},
  ),
  0x00000403: ClusterInfo(
    name: 'Pressure Measurement',
    attributes: {
      0x00000000: AttributeInfo(
        name: 'Measured Value',
        type: MatterValueType.unknown,
      ),
      0x00000001: AttributeInfo(
        name: 'Min Measured Value',
        type: MatterValueType.unknown,
      ),
      0x00000002: AttributeInfo(
        name: 'Max Measured Value',
        type: MatterValueType.unknown,
      ),
      0x00000003: AttributeInfo(
        name: 'Tolerance',
        type: MatterValueType.unknown,
      ),
      0x00000010: AttributeInfo(
        name: 'Scaled Value',
        type: MatterValueType.unknown,
      ),
      0x00000011: AttributeInfo(
        name: 'Min Scaled Value',
        type: MatterValueType.unknown,
      ),
      0x00000012: AttributeInfo(
        name: 'Max Scaled Value',
        type: MatterValueType.unknown,
      ),
      0x00000013: AttributeInfo(
        name: 'Scaled Tolerance',
        type: MatterValueType.unknown,
      ),
      0x00000014: AttributeInfo(name: 'Scale', type: MatterValueType.unknown),
      0x0000FFF8: AttributeInfo(
        name: 'Generated Command List',
        type: MatterValueType.array,
      ),
      0x0000FFF9: AttributeInfo(
        name: 'Accepted Command List',
        type: MatterValueType.array,
      ),
      0x0000FFFA: AttributeInfo(
        name: 'Event List',
        type: MatterValueType.array,
      ),
      0x0000FFFC: AttributeInfo(
        name: 'Feature Map',
        type: MatterValueType.unknown,
      ),
      0x0000FFFD: AttributeInfo(
        name: 'Cluster Revision',
        type: MatterValueType.unknown,
      ),
    },
    commands: {},
  ),
  0x00000404: ClusterInfo(
    name: 'Flow Measurement',
    attributes: {
      0x00000000: AttributeInfo(
        name: 'Measured Value',
        type: MatterValueType.unknown,
      ),
      0x00000001: AttributeInfo(
        name: 'Min Measured Value',
        type: MatterValueType.unknown,
      ),
      0x00000002: AttributeInfo(
        name: 'Max Measured Value',
        type: MatterValueType.unknown,
      ),
      0x00000003: AttributeInfo(
        name: 'Tolerance',
        type: MatterValueType.unknown,
      ),
      0x0000FFF8: AttributeInfo(
        name: 'Generated Command List',
        type: MatterValueType.array,
      ),
      0x0000FFF9: AttributeInfo(
        name: 'Accepted Command List',
        type: MatterValueType.array,
      ),
      0x0000FFFA: AttributeInfo(
        name: 'Event List',
        type: MatterValueType.array,
      ),
      0x0000FFFC: AttributeInfo(
        name: 'Feature Map',
        type: MatterValueType.unknown,
      ),
      0x0000FFFD: AttributeInfo(
        name: 'Cluster Revision',
        type: MatterValueType.unknown,
      ),
    },
    commands: {},
  ),
  0x00000405: ClusterInfo(
    name: 'Relative Humidity Measurement',
    attributes: {
      0x00000000: AttributeInfo(
        name: 'Measured Value',
        type: MatterValueType.unknown,
      ),
      0x00000001: AttributeInfo(
        name: 'Min Measured Value',
        type: MatterValueType.unknown,
      ),
      0x00000002: AttributeInfo(
        name: 'Max Measured Value',
        type: MatterValueType.unknown,
      ),
      0x00000003: AttributeInfo(
        name: 'Tolerance',
        type: MatterValueType.unknown,
      ),
      0x0000FFF8: AttributeInfo(
        name: 'Generated Command List',
        type: MatterValueType.array,
      ),
      0x0000FFF9: AttributeInfo(
        name: 'Accepted Command List',
        type: MatterValueType.array,
      ),
      0x0000FFFA: AttributeInfo(
        name: 'Event List',
        type: MatterValueType.array,
      ),
      0x0000FFFC: AttributeInfo(
        name: 'Feature Map',
        type: MatterValueType.unknown,
      ),
      0x0000FFFD: AttributeInfo(
        name: 'Cluster Revision',
        type: MatterValueType.unknown,
      ),
    },
    commands: {},
  ),
  0x00000406: ClusterInfo(
    name: 'Occupancy Sensing',
    attributes: {
      0x00000000: AttributeInfo(
        name: 'Occupancy',
        type: MatterValueType.unknown,
      ),
      0x00000001: AttributeInfo(
        name: 'Occupancy Sensor Type',
        type: MatterValueType.unknown,
      ),
      0x00000002: AttributeInfo(
        name: 'Occupancy Sensor Type Bitmap',
        type: MatterValueType.unknown,
      ),
      0x00000003: AttributeInfo(
        name: 'Hold Time',
        type: MatterValueType.unknown,
      ),
      0x00000004: AttributeInfo(
        name: 'Hold Time Limits',
        type: MatterValueType.struct,
      ),
      0x00000010: AttributeInfo(
        name: 'PIROccupied To Unoccupied Delay',
        type: MatterValueType.unknown,
      ),
      0x00000011: AttributeInfo(
        name: 'PIRUnoccupied To Occupied Delay',
        type: MatterValueType.unknown,
      ),
      0x00000012: AttributeInfo(
        name: 'PIRUnoccupied To Occupied Threshold',
        type: MatterValueType.unknown,
      ),
      0x00000020: AttributeInfo(
        name: 'Ultrasonic Occupied To Unoccupied Delay',
        type: MatterValueType.unknown,
      ),
      0x00000021: AttributeInfo(
        name: 'Ultrasonic Unoccupied To Occupied Delay',
        type: MatterValueType.unknown,
      ),
      0x00000022: AttributeInfo(
        name: 'Ultrasonic Unoccupied To Occupied Threshold',
        type: MatterValueType.unknown,
      ),
      0x00000030: AttributeInfo(
        name: 'Physical Contact Occupied To Unoccupied Delay',
        type: MatterValueType.unknown,
      ),
      0x00000031: AttributeInfo(
        name: 'Physical Contact Unoccupied To Occupied Delay',
        type: MatterValueType.unknown,
      ),
      0x00000032: AttributeInfo(
        name: 'Physical Contact Unoccupied To Occupied Threshold',
        type: MatterValueType.unknown,
      ),
      0x0000FFF8: AttributeInfo(
        name: 'Generated Command List',
        type: MatterValueType.array,
      ),
      0x0000FFF9: AttributeInfo(
        name: 'Accepted Command List',
        type: MatterValueType.array,
      ),
      0x0000FFFA: AttributeInfo(
        name: 'Event List',
        type: MatterValueType.array,
      ),
      0x0000FFFC: AttributeInfo(
        name: 'Feature Map',
        type: MatterValueType.unknown,
      ),
      0x0000FFFD: AttributeInfo(
        name: 'Cluster Revision',
        type: MatterValueType.unknown,
      ),
    },
    commands: {},
  ),
};
