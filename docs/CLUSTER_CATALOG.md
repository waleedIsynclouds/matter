# Matter Cluster Catalog

_Generated from `lib/src/data_model/cluster_catalog_data.g.dart` by `tool/generate_cluster_catalog_doc.dart`. That data is itself generated from the ZGMatter framework headers by `tool/generate_cluster_catalog.dart`. Regenerate this document any time the catalog changes rather than editing it by hand._

**25 clusters · 501 attributes · 123 commands**

## Contents

- [Groups (0x00000004)](#groups-4)
- [On Off (0x00000006)](#on-off-6)
- [Level Control (0x00000008)](#level-control-8)
- [Descriptor (0x0000001D)](#descriptor-1d)
- [Basic Information (0x00000028)](#basic-information-28)
- [OTASoftware Update Provider (0x00000029)](#otasoftware-update-provider-29)
- [OTASoftware Update Requestor (0x0000002A)](#otasoftware-update-requestor-2a)
- [General Diagnostics (0x00000033)](#general-diagnostics-33)
- [Software Diagnostics (0x00000034)](#software-diagnostics-34)
- [Thread Network Diagnostics (0x00000035)](#thread-network-diagnostics-35)
- [Wi-Fi Network Diagnostics (0x00000036)](#wi-fi-network-diagnostics-36)
- [Administrator Commissioning (0x0000003C)](#administrator-commissioning-3c)
- [Operational Credentials (0x0000003E)](#operational-credentials-3e)
- [Group Key Management (0x0000003F)](#group-key-management-3f)
- [Scenes Management (0x00000062)](#scenes-management-62)
- [Door Lock (0x00000101)](#door-lock-101)
- [Window Covering (0x00000102)](#window-covering-102)
- [Thermostat (0x00000201)](#thermostat-201)
- [Color Control (0x00000300)](#color-control-300)
- [Illuminance Measurement (0x00000400)](#illuminance-measurement-400)
- [Temperature Measurement (0x00000402)](#temperature-measurement-402)
- [Pressure Measurement (0x00000403)](#pressure-measurement-403)
- [Flow Measurement (0x00000404)](#flow-measurement-404)
- [Relative Humidity Measurement (0x00000405)](#relative-humidity-measurement-405)
- [Occupancy Sensing (0x00000406)](#occupancy-sensing-406)

---

## Groups (0x00000004)

6 attributes, 6 commands.

### Attributes

| ID | Name | Type |
| --- | --- | --- |
| `0x00000000` | Name Support | unknown |
| `0x0000FFF8` | Generated Command List | array |
| `0x0000FFF9` | Accepted Command List | array |
| `0x0000FFFA` | Event List | array |
| `0x0000FFFC` | Feature Map | unknown |
| `0x0000FFFD` | Cluster Revision | unknown |

### Commands

**Add Group** (`0x00`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | group ID | unknown | no |
| 1 | group Name | string | no |

**View Group** (`0x01`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | group ID | unknown | no |

**Get Group Membership** (`0x02`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | group List | array | no |

**Remove Group** (`0x03`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | group ID | unknown | no |

**Remove All Groups** (`0x04`)

_No fields._

**Add Group If Identifying** (`0x05`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | group ID | unknown | no |
| 1 | group Name | string | no |

---

## On Off (0x00000006)

10 attributes, 6 commands.

### Attributes

| ID | Name | Type |
| --- | --- | --- |
| `0x00000000` | On Off | unknown |
| `0x00004000` | Global Scene Control | unknown |
| `0x00004001` | On Time | unknown |
| `0x00004002` | Off Wait Time | unknown |
| `0x00004003` | Start Up On Off | unknown |
| `0x0000FFF8` | Generated Command List | array |
| `0x0000FFF9` | Accepted Command List | array |
| `0x0000FFFA` | Event List | array |
| `0x0000FFFC` | Feature Map | unknown |
| `0x0000FFFD` | Cluster Revision | unknown |

### Commands

**Off** (`0x00`)

_No fields._

**On** (`0x01`)

_No fields._

**Toggle** (`0x02`)

_No fields._

**Off With Effect** (`0x40`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | effect Identifier | unknown | no |
| 1 | effect Variant | unknown | no |

**On With Recall Global Scene** (`0x41`)

_No fields._

**On With Timed Off** (`0x42`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | on Off Control | unknown | no |
| 1 | on Time | unknown | no |
| 2 | off Wait Time | unknown | no |

---

## Level Control (0x00000008)

19 attributes, 9 commands.

### Attributes

| ID | Name | Type |
| --- | --- | --- |
| `0x00000000` | Current Level | unknown |
| `0x00000001` | Remaining Time | unknown |
| `0x00000002` | Min Level | unknown |
| `0x00000003` | Max Level | unknown |
| `0x00000004` | Current Frequency | unknown |
| `0x00000005` | Min Frequency | unknown |
| `0x00000006` | Max Frequency | unknown |
| `0x0000000F` | Options | unknown |
| `0x00000010` | On Off Transition Time | unknown |
| `0x00000011` | On Level | unknown |
| `0x00000012` | On Transition Time | unknown |
| `0x00000013` | Off Transition Time | unknown |
| `0x00000014` | Default Move Rate | unknown |
| `0x00004000` | Start Up Current Level | unknown |
| `0x0000FFF8` | Generated Command List | array |
| `0x0000FFF9` | Accepted Command List | array |
| `0x0000FFFA` | Event List | array |
| `0x0000FFFC` | Feature Map | unknown |
| `0x0000FFFD` | Cluster Revision | unknown |

### Commands

**Move To Level** (`0x00`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | level | unknown | no |
| 1 | transition Time | unknown | yes |
| 2 | options Mask | unknown | no |
| 3 | options Override | unknown | no |

**Move** (`0x01`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | move Mode | unknown | no |
| 1 | rate | unknown | yes |
| 2 | options Mask | unknown | no |
| 3 | options Override | unknown | no |

**Step** (`0x02`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | step Mode | unknown | no |
| 1 | step Size | unknown | no |
| 2 | transition Time | unknown | yes |
| 3 | options Mask | unknown | no |
| 4 | options Override | unknown | no |

**Stop** (`0x03`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | options Mask | unknown | no |
| 1 | options Override | unknown | no |

**Move To Level With On Off** (`0x04`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | level | unknown | no |
| 1 | transition Time | unknown | yes |
| 2 | options Mask | unknown | no |
| 3 | options Override | unknown | no |

**Move With On Off** (`0x05`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | move Mode | unknown | no |
| 1 | rate | unknown | yes |
| 2 | options Mask | unknown | no |
| 3 | options Override | unknown | no |

**Step With On Off** (`0x06`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | step Mode | unknown | no |
| 1 | step Size | unknown | no |
| 2 | transition Time | unknown | yes |
| 3 | options Mask | unknown | no |
| 4 | options Override | unknown | no |

**Stop With On Off** (`0x07`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | options Mask | unknown | no |
| 1 | options Override | unknown | no |

**Move To Closest Frequency** (`0x08`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | frequency | unknown | no |

---

## Descriptor (0x0000001D)

10 attributes, 0 commands.

### Attributes

| ID | Name | Type |
| --- | --- | --- |
| `0x00000000` | Device Type List | array |
| `0x00000001` | Server List | array |
| `0x00000002` | Client List | array |
| `0x00000003` | Parts List | array |
| `0x00000004` | Tag List | array |
| `0x0000FFF8` | Generated Command List | array |
| `0x0000FFF9` | Accepted Command List | array |
| `0x0000FFFA` | Event List | array |
| `0x0000FFFC` | Feature Map | unknown |
| `0x0000FFFD` | Cluster Revision | unknown |

### Commands

_No commands cataloged._
---

## Basic Information (0x00000028)

28 attributes, 1 commands.

### Attributes

| ID | Name | Type |
| --- | --- | --- |
| `0x00000000` | Data Model Revision | unknown |
| `0x00000001` | Vendor Name | string |
| `0x00000002` | Vendor ID | unknown |
| `0x00000003` | Product Name | string |
| `0x00000004` | Product ID | unknown |
| `0x00000005` | Node Label | string |
| `0x00000006` | Location | string |
| `0x00000007` | Hardware Version | unknown |
| `0x00000008` | Hardware Version String | string |
| `0x00000009` | Software Version | unknown |
| `0x0000000A` | Software Version String | string |
| `0x0000000B` | Manufacturing Date | string |
| `0x0000000C` | Part Number | string |
| `0x0000000D` | Product URL | string |
| `0x0000000E` | Product Label | string |
| `0x0000000F` | Serial Number | string |
| `0x00000010` | Local Config Disabled | unknown |
| `0x00000011` | Reachable | unknown |
| `0x00000012` | Unique ID | string |
| `0x00000013` | Capability Minima | struct |
| `0x00000014` | Product Appearance | struct |
| `0x00000015` | Specification Version | unknown |
| `0x00000016` | Max Paths Per Invoke | unknown |
| `0x0000FFF8` | Generated Command List | array |
| `0x0000FFF9` | Accepted Command List | array |
| `0x0000FFFA` | Event List | array |
| `0x0000FFFC` | Feature Map | unknown |
| `0x0000FFFD` | Cluster Revision | unknown |

### Commands

**Mfg Specific Ping** (`0x10020000`)

_No fields._

---

## OTASoftware Update Provider (0x00000029)

5 attributes, 5 commands.

### Attributes

| ID | Name | Type |
| --- | --- | --- |
| `0x0000FFF8` | Generated Command List | array |
| `0x0000FFF9` | Accepted Command List | array |
| `0x0000FFFA` | Event List | array |
| `0x0000FFFC` | Feature Map | unknown |
| `0x0000FFFD` | Cluster Revision | unknown |

### Commands

**Query Image** (`0x00`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | vendor ID | unknown | no |
| 1 | product ID | unknown | no |
| 2 | software Version | unknown | no |
| 3 | protocols Supported | array | no |
| 4 | hardware Version | unknown | yes |
| 5 | location | string | yes |
| 6 | requestor Can Consent | unknown | yes |
| 7 | metadata For Provider | octet string | yes |

**Query Image Response** (`0x01`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | status | unknown | no |
| 1 | delayed Action Time | unknown | yes |
| 2 | image URI | string | yes |
| 3 | software Version | unknown | yes |
| 4 | software Version String | string | yes |
| 5 | update Token | octet string | yes |
| 6 | user Consent Needed | unknown | yes |
| 7 | metadata For Requestor | octet string | yes |

**Apply Update Request** (`0x02`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | update Token | octet string | no |

**Apply Update Response** (`0x03`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | action | unknown | no |
| 1 | delayed Action Time | unknown | no |

**Notify Update Applied** (`0x04`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | update Token | octet string | no |
| 1 | software Version | unknown | no |

---

## OTASoftware Update Requestor (0x0000002A)

9 attributes, 1 commands.

### Attributes

| ID | Name | Type |
| --- | --- | --- |
| `0x00000000` | Default OTAProviders | array |
| `0x00000001` | Update Possible | unknown |
| `0x00000002` | Update State | unknown |
| `0x00000003` | Update State Progress | unknown |
| `0x0000FFF8` | Generated Command List | array |
| `0x0000FFF9` | Accepted Command List | array |
| `0x0000FFFA` | Event List | array |
| `0x0000FFFC` | Feature Map | unknown |
| `0x0000FFFD` | Cluster Revision | unknown |

### Commands

**Announce OTAProvider** (`0x00`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | provider Node ID | unknown | no |
| 1 | vendor ID | unknown | no |
| 2 | announcement Reason | unknown | no |
| 3 | metadata For Node | octet string | yes |
| 4 | endpoint | unknown | no |

---

## General Diagnostics (0x00000033)

14 attributes, 5 commands.

### Attributes

| ID | Name | Type |
| --- | --- | --- |
| `0x00000000` | Network Interfaces | array |
| `0x00000001` | Reboot Count | unknown |
| `0x00000002` | Up Time | unknown |
| `0x00000003` | Total Operational Hours | unknown |
| `0x00000004` | Boot Reason | unknown |
| `0x00000005` | Active Hardware Faults | array |
| `0x00000006` | Active Radio Faults | array |
| `0x00000007` | Active Network Faults | array |
| `0x00000008` | Test Event Triggers Enabled | unknown |
| `0x0000FFF8` | Generated Command List | array |
| `0x0000FFF9` | Accepted Command List | array |
| `0x0000FFFA` | Event List | array |
| `0x0000FFFC` | Feature Map | unknown |
| `0x0000FFFD` | Cluster Revision | unknown |

### Commands

**Test Event Trigger** (`0x00`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | enable Key | octet string | no |
| 1 | event Trigger | unknown | no |

**Time Snapshot** (`0x01`)

_No fields._

**Time Snapshot Response** (`0x02`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | system Time Ms | unknown | no |
| 1 | posix Time Ms | unknown | yes |

**Payload Test Request** (`0x03`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | enable Key | octet string | no |
| 1 | value | unknown | no |

**Payload Test Response** (`0x04`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | payload | octet string | no |

---

## Software Diagnostics (0x00000034)

9 attributes, 1 commands.

### Attributes

| ID | Name | Type |
| --- | --- | --- |
| `0x00000000` | Thread Metrics | array |
| `0x00000001` | Current Heap Free | unknown |
| `0x00000002` | Current Heap Used | unknown |
| `0x00000003` | Current Heap High Watermark | unknown |
| `0x0000FFF8` | Generated Command List | array |
| `0x0000FFF9` | Accepted Command List | array |
| `0x0000FFFA` | Event List | array |
| `0x0000FFFC` | Feature Map | unknown |
| `0x0000FFFD` | Cluster Revision | unknown |

### Commands

**Reset Watermarks** (`0x00`)

_No fields._

---

## Thread Network Diagnostics (0x00000035)

68 attributes, 1 commands.

### Attributes

| ID | Name | Type |
| --- | --- | --- |
| `0x00000000` | Channel | unknown |
| `0x00000001` | Routing Role | unknown |
| `0x00000002` | Network Name | string |
| `0x00000003` | Pan Id | unknown |
| `0x00000004` | Extended Pan Id | unknown |
| `0x00000005` | Mesh Local Prefix | octet string |
| `0x00000006` | Overrun Count | unknown |
| `0x00000007` | Neighbor Table | array |
| `0x00000008` | Route Table | array |
| `0x00000009` | Partition Id | unknown |
| `0x0000000A` | Weighting | unknown |
| `0x0000000B` | Data Version | unknown |
| `0x0000000C` | Stable Data Version | unknown |
| `0x0000000D` | Leader Router Id | unknown |
| `0x0000000E` | Detached Role Count | unknown |
| `0x0000000F` | Child Role Count | unknown |
| `0x00000010` | Router Role Count | unknown |
| `0x00000011` | Leader Role Count | unknown |
| `0x00000012` | Attach Attempt Count | unknown |
| `0x00000013` | Partition Id Change Count | unknown |
| `0x00000014` | Better Partition Attach Attempt Count | unknown |
| `0x00000015` | Parent Change Count | unknown |
| `0x00000016` | Tx Total Count | unknown |
| `0x00000017` | Tx Unicast Count | unknown |
| `0x00000018` | Tx Broadcast Count | unknown |
| `0x00000019` | Tx Ack Requested Count | unknown |
| `0x0000001A` | Tx Acked Count | unknown |
| `0x0000001B` | Tx No Ack Requested Count | unknown |
| `0x0000001C` | Tx Data Count | unknown |
| `0x0000001D` | Tx Data Poll Count | unknown |
| `0x0000001E` | Tx Beacon Count | unknown |
| `0x0000001F` | Tx Beacon Request Count | unknown |
| `0x00000020` | Tx Other Count | unknown |
| `0x00000021` | Tx Retry Count | unknown |
| `0x00000022` | Tx Direct Max Retry Expiry Count | unknown |
| `0x00000023` | Tx Indirect Max Retry Expiry Count | unknown |
| `0x00000024` | Tx Err Cca Count | unknown |
| `0x00000025` | Tx Err Abort Count | unknown |
| `0x00000026` | Tx Err Busy Channel Count | unknown |
| `0x00000027` | Rx Total Count | unknown |
| `0x00000028` | Rx Unicast Count | unknown |
| `0x00000029` | Rx Broadcast Count | unknown |
| `0x0000002A` | Rx Data Count | unknown |
| `0x0000002B` | Rx Data Poll Count | unknown |
| `0x0000002C` | Rx Beacon Count | unknown |
| `0x0000002D` | Rx Beacon Request Count | unknown |
| `0x0000002E` | Rx Other Count | unknown |
| `0x0000002F` | Rx Address Filtered Count | unknown |
| `0x00000030` | Rx Dest Addr Filtered Count | unknown |
| `0x00000031` | Rx Duplicated Count | unknown |
| `0x00000032` | Rx Err No Frame Count | unknown |
| `0x00000033` | Rx Err Unknown Neighbor Count | unknown |
| `0x00000034` | Rx Err Invalid Src Addr Count | unknown |
| `0x00000035` | Rx Err Sec Count | unknown |
| `0x00000036` | Rx Err Fcs Count | unknown |
| `0x00000037` | Rx Err Other Count | unknown |
| `0x00000038` | Active Timestamp | unknown |
| `0x00000039` | Pending Timestamp | unknown |
| `0x0000003A` | Delay | unknown |
| `0x0000003B` | Security Policy | struct |
| `0x0000003C` | Channel Page0 Mask | octet string |
| `0x0000003D` | Operational Dataset Components | struct |
| `0x0000003E` | Active Network Faults List | array |
| `0x0000FFF8` | Generated Command List | array |
| `0x0000FFF9` | Accepted Command List | array |
| `0x0000FFFA` | Event List | array |
| `0x0000FFFC` | Feature Map | unknown |
| `0x0000FFFD` | Cluster Revision | unknown |

### Commands

**Reset Counts** (`0x00`)

_No fields._

---

## Wi-Fi Network Diagnostics (0x00000036)

18 attributes, 1 commands.

### Attributes

| ID | Name | Type |
| --- | --- | --- |
| `0x00000000` | BSSID | octet string |
| `0x00000001` | Security Type | unknown |
| `0x00000002` | Wi-Fi Version | unknown |
| `0x00000003` | Channel Number | unknown |
| `0x00000004` | RSSI | unknown |
| `0x00000005` | Beacon Lost Count | unknown |
| `0x00000006` | Beacon Rx Count | unknown |
| `0x00000007` | Packet Multicast Rx Count | unknown |
| `0x00000008` | Packet Multicast Tx Count | unknown |
| `0x00000009` | Packet Unicast Rx Count | unknown |
| `0x0000000A` | Packet Unicast Tx Count | unknown |
| `0x0000000B` | Current Max Rate | unknown |
| `0x0000000C` | Overrun Count | unknown |
| `0x0000FFF8` | Generated Command List | array |
| `0x0000FFF9` | Accepted Command List | array |
| `0x0000FFFA` | Event List | array |
| `0x0000FFFC` | Feature Map | unknown |
| `0x0000FFFD` | Cluster Revision | unknown |

### Commands

**Reset Counts** (`0x00`)

_No fields._

---

## Administrator Commissioning (0x0000003C)

8 attributes, 3 commands.

### Attributes

| ID | Name | Type |
| --- | --- | --- |
| `0x00000000` | Window Status | unknown |
| `0x00000001` | Admin Fabric Index | unknown |
| `0x00000002` | Admin Vendor Id | unknown |
| `0x0000FFF8` | Generated Command List | array |
| `0x0000FFF9` | Accepted Command List | array |
| `0x0000FFFA` | Event List | array |
| `0x0000FFFC` | Feature Map | unknown |
| `0x0000FFFD` | Cluster Revision | unknown |

### Commands

**Open Commissioning Window** (`0x00`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | commissioning Timeout | unknown | no |
| 1 | pake Passcode Verifier | octet string | no |
| 2 | discriminator | unknown | no |
| 3 | iterations | unknown | no |
| 4 | salt | octet string | no |

**Open Basic Commissioning Window** (`0x01`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | commissioning Timeout | unknown | no |

**Revoke Commissioning** (`0x02`)

_No fields._

---

## Operational Credentials (0x0000003E)

11 attributes, 12 commands.

### Attributes

| ID | Name | Type |
| --- | --- | --- |
| `0x00000000` | NOCs | array |
| `0x00000001` | Fabrics | array |
| `0x00000002` | Supported Fabrics | unknown |
| `0x00000003` | Commissioned Fabrics | unknown |
| `0x00000004` | Trusted Root Certificates | array |
| `0x00000005` | Current Fabric Index | unknown |
| `0x0000FFF8` | Generated Command List | array |
| `0x0000FFF9` | Accepted Command List | array |
| `0x0000FFFA` | Event List | array |
| `0x0000FFFC` | Feature Map | unknown |
| `0x0000FFFD` | Cluster Revision | unknown |

### Commands

**Attestation Request** (`0x00`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | attestation Nonce | octet string | no |

**Attestation Response** (`0x01`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | attestation Elements | octet string | no |
| 1 | attestation Signature | octet string | no |

**Certificate Chain Request** (`0x02`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | certificate Type | unknown | no |

**Certificate Chain Response** (`0x03`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | certificate | octet string | no |

**CSRRequest** (`0x04`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | csr Nonce | octet string | no |
| 1 | is For Update NOC | unknown | yes |

**CSRResponse** (`0x05`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | nocsr Elements | octet string | no |
| 1 | attestation Signature | octet string | no |

**Add NOC** (`0x06`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | noc Value | octet string | no |
| 1 | icac Value | octet string | yes |
| 2 | ipk Value | octet string | no |
| 3 | case Admin Subject | unknown | no |
| 4 | admin Vendor Id | unknown | no |

**Update NOC** (`0x07`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | noc Value | octet string | no |
| 1 | icac Value | octet string | yes |

**NOCResponse** (`0x08`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | status Code | unknown | no |
| 1 | fabric Index | unknown | yes |
| 2 | debug Text | string | yes |

**Update Fabric Label** (`0x09`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | label | string | no |

**Remove Fabric** (`0x0A`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | fabric Index | unknown | no |

**Add Trusted Root Certificate** (`0x0B`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | root CACertificate | octet string | no |

---

## Group Key Management (0x0000003F)

9 attributes, 6 commands.

### Attributes

| ID | Name | Type |
| --- | --- | --- |
| `0x00000000` | Group Key Map | array |
| `0x00000001` | Group Table | array |
| `0x00000002` | Max Groups Per Fabric | unknown |
| `0x00000003` | Max Group Keys Per Fabric | unknown |
| `0x0000FFF8` | Generated Command List | array |
| `0x0000FFF9` | Accepted Command List | array |
| `0x0000FFFA` | Event List | array |
| `0x0000FFFC` | Feature Map | unknown |
| `0x0000FFFD` | Cluster Revision | unknown |

### Commands

**Key Set Write** (`0x00`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | group Key Set | struct | no |

**Key Set Read** (`0x01`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | group Key Set ID | unknown | no |

**Key Set Read Response** (`0x02`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | group Key Set | struct | no |

**Key Set Remove** (`0x03`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | group Key Set ID | unknown | no |

**Key Set Read All Indices** (`0x04`)

_No fields._

**Key Set Read All Indices Response** (`0x05`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | group Key Set IDs | array | no |

---

## Scenes Management (0x00000062)

8 attributes, 8 commands.

### Attributes

| ID | Name | Type |
| --- | --- | --- |
| `0x00000000` | Last Configured By | unknown |
| `0x00000001` | Scene Table Size | unknown |
| `0x00000002` | Fabric Scene Info | array |
| `0x0000FFF8` | Generated Command List | array |
| `0x0000FFF9` | Accepted Command List | array |
| `0x0000FFFA` | Event List | array |
| `0x0000FFFC` | Feature Map | unknown |
| `0x0000FFFD` | Cluster Revision | unknown |

### Commands

**Add Scene Response** (`0x00`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | status | unknown | no |
| 1 | group ID | unknown | no |
| 2 | scene ID | unknown | no |

**View Scene Response** (`0x01`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | status | unknown | no |
| 1 | group ID | unknown | no |
| 2 | scene ID | unknown | no |
| 3 | transition Time | unknown | yes |
| 4 | scene Name | string | yes |
| 5 | extension Field Sets | array | yes |

**Remove Scene Response** (`0x02`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | status | unknown | no |
| 1 | group ID | unknown | no |
| 2 | scene ID | unknown | no |

**Remove All Scenes Response** (`0x03`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | status | unknown | no |
| 1 | group ID | unknown | no |

**Store Scene Response** (`0x04`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | status | unknown | no |
| 1 | group ID | unknown | no |
| 2 | scene ID | unknown | no |

**Recall Scene** (`0x05`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | group ID | unknown | no |
| 1 | scene ID | unknown | no |
| 2 | transition Time | unknown | yes |

**Get Scene Membership Response** (`0x06`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | status | unknown | no |
| 1 | capacity | unknown | yes |
| 2 | group ID | unknown | no |
| 3 | scene List | array | yes |

**Copy Scene Response** (`0x40`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | status | unknown | no |
| 1 | group Identifier From | unknown | no |
| 2 | scene Identifier From | unknown | no |

---

## Door Lock (0x00000101)

50 attributes, 24 commands.

### Attributes

| ID | Name | Type |
| --- | --- | --- |
| `0x00000000` | Lock State | unknown |
| `0x00000001` | Lock Type | unknown |
| `0x00000002` | Actuator Enabled | unknown |
| `0x00000003` | Door State | unknown |
| `0x00000004` | Door Open Events | unknown |
| `0x00000005` | Door Closed Events | unknown |
| `0x00000006` | Open Period | unknown |
| `0x00000011` | Number Of Total Users Supported | unknown |
| `0x00000012` | Number Of PINUsers Supported | unknown |
| `0x00000013` | Number Of RFIDUsers Supported | unknown |
| `0x00000014` | Number Of Week Day Schedules Supported Per User | unknown |
| `0x00000015` | Number Of Year Day Schedules Supported Per User | unknown |
| `0x00000016` | Number Of Holiday Schedules Supported | unknown |
| `0x00000017` | Max PINCode Length | unknown |
| `0x00000018` | Min PINCode Length | unknown |
| `0x00000019` | Max RFIDCode Length | unknown |
| `0x0000001A` | Min RFIDCode Length | unknown |
| `0x0000001B` | Credential Rules Support | unknown |
| `0x0000001C` | Number Of Credentials Supported Per User | unknown |
| `0x00000021` | Language | string |
| `0x00000022` | LEDSettings | unknown |
| `0x00000023` | Auto Relock Time | unknown |
| `0x00000024` | Sound Volume | unknown |
| `0x00000025` | Operating Mode | unknown |
| `0x00000026` | Supported Operating Modes | unknown |
| `0x00000027` | Default Configuration Register | unknown |
| `0x00000028` | Enable Local Programming | unknown |
| `0x00000029` | Enable One Touch Locking | unknown |
| `0x0000002A` | Enable Inside Status LED | unknown |
| `0x0000002B` | Enable Privacy Mode Button | unknown |
| `0x0000002C` | Local Programming Features | unknown |
| `0x00000030` | Wrong Code Entry Limit | unknown |
| `0x00000031` | User Code Temporary Disable Time | unknown |
| `0x00000032` | Send PINOver The Air | unknown |
| `0x00000033` | Require PINfor Remote Operation | unknown |
| `0x00000035` | Expiring User Timeout | unknown |
| `0x00000080` | Aliro Reader Verification Key | octet string |
| `0x00000081` | Aliro Reader Group Identifier | octet string |
| `0x00000082` | Aliro Reader Group Sub Identifier | octet string |
| `0x00000083` | Aliro Expedited Transaction Supported Protocol Versions | array |
| `0x00000084` | Aliro Group Resolving Key | octet string |
| `0x00000085` | Aliro Supported BLEUWBProtocol Versions | array |
| `0x00000086` | Aliro BLEAdvertising Version | unknown |
| `0x00000087` | Number Of Aliro Credential Issuer Keys Supported | unknown |
| `0x00000088` | Number Of Aliro Endpoint Keys Supported | unknown |
| `0x0000FFF8` | Generated Command List | array |
| `0x0000FFF9` | Accepted Command List | array |
| `0x0000FFFA` | Event List | array |
| `0x0000FFFC` | Feature Map | unknown |
| `0x0000FFFD` | Cluster Revision | unknown |

### Commands

**Lock Door** (`0x00`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | pin Code | octet string | yes |

**Unlock Door** (`0x01`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | pin Code | octet string | yes |

**Unlock With Timeout** (`0x03`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | timeout | unknown | no |
| 1 | pin Code | octet string | yes |

**Set Week Day Schedule** (`0x0B`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | week Day Index | unknown | no |
| 1 | user Index | unknown | no |
| 2 | days Mask | unknown | no |
| 3 | start Hour | unknown | no |
| 4 | start Minute | unknown | no |
| 5 | end Hour | unknown | no |
| 6 | end Minute | unknown | no |

**Get Week Day Schedule Response** (`0x0C`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | week Day Index | unknown | no |
| 1 | user Index | unknown | no |
| 2 | status | unknown | no |
| 3 | days Mask | unknown | yes |
| 4 | start Hour | unknown | yes |
| 5 | start Minute | unknown | yes |
| 6 | end Hour | unknown | yes |
| 7 | end Minute | unknown | yes |

**Clear Week Day Schedule** (`0x0D`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | week Day Index | unknown | no |
| 1 | user Index | unknown | no |

**Set Year Day Schedule** (`0x0E`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | year Day Index | unknown | no |
| 1 | user Index | unknown | no |
| 2 | local Start Time | unknown | no |
| 3 | local End Time | unknown | no |

**Get Year Day Schedule Response** (`0x0F`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | year Day Index | unknown | no |
| 1 | user Index | unknown | no |
| 2 | status | unknown | no |
| 3 | local Start Time | unknown | yes |
| 4 | local End Time | unknown | yes |

**Clear Year Day Schedule** (`0x10`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | year Day Index | unknown | no |
| 1 | user Index | unknown | no |

**Set Holiday Schedule** (`0x11`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | holiday Index | unknown | no |
| 1 | local Start Time | unknown | no |
| 2 | local End Time | unknown | no |
| 3 | operating Mode | unknown | no |

**Get Holiday Schedule Response** (`0x12`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | holiday Index | unknown | no |
| 1 | status | unknown | no |
| 2 | local Start Time | unknown | yes |
| 3 | local End Time | unknown | yes |
| 4 | operating Mode | unknown | yes |

**Clear Holiday Schedule** (`0x13`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | holiday Index | unknown | no |

**Set User** (`0x1A`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | operation Type | unknown | no |
| 1 | user Index | unknown | no |
| 2 | user Name | string | yes |
| 3 | user Unique ID | unknown | yes |
| 4 | user Status | unknown | yes |
| 5 | user Type | unknown | yes |
| 6 | credential Rule | unknown | yes |

**Get User** (`0x1B`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | user Index | unknown | no |

**Get User Response** (`0x1C`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | user Index | unknown | no |
| 1 | user Name | string | yes |
| 2 | user Unique ID | unknown | yes |
| 3 | user Status | unknown | yes |
| 4 | user Type | unknown | yes |
| 5 | credential Rule | unknown | yes |
| 6 | credentials | array | yes |
| 7 | creator Fabric Index | unknown | yes |
| 8 | last Modified Fabric Index | unknown | yes |
| 9 | next User Index | unknown | yes |

**Clear User** (`0x1D`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | user Index | unknown | no |

**Set Credential** (`0x22`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | operation Type | unknown | no |
| 1 | credential | struct | no |
| 2 | credential Data | octet string | no |
| 3 | user Index | unknown | yes |
| 4 | user Status | unknown | yes |
| 5 | user Type | unknown | yes |

**Set Credential Response** (`0x23`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | status | unknown | no |
| 1 | user Index | unknown | yes |
| 2 | next Credential Index | unknown | yes |

**Get Credential Status** (`0x24`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | credential | struct | no |

**Get Credential Status Response** (`0x25`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | credential Exists | unknown | no |
| 1 | user Index | unknown | yes |
| 2 | creator Fabric Index | unknown | yes |
| 3 | last Modified Fabric Index | unknown | yes |
| 4 | next Credential Index | unknown | yes |
| 5 | credential Data | octet string | yes |

**Clear Credential** (`0x26`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | credential | struct | yes |

**Unbolt Door** (`0x27`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | pin Code | octet string | yes |

**Set Aliro Reader Config** (`0x28`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | signing Key | octet string | no |
| 1 | verification Key | octet string | no |
| 2 | group Identifier | octet string | no |
| 3 | group Resolving Key | octet string | yes |

**Clear Aliro Reader Config** (`0x29`)

_No fields._

---

## Window Covering (0x00000102)

27 attributes, 7 commands.

### Attributes

| ID | Name | Type |
| --- | --- | --- |
| `0x00000000` | Type | unknown |
| `0x00000001` | Physical Closed Limit Lift | unknown |
| `0x00000002` | Physical Closed Limit Tilt | unknown |
| `0x00000003` | Current Position Lift | unknown |
| `0x00000004` | Current Position Tilt | unknown |
| `0x00000005` | Number Of Actuations Lift | unknown |
| `0x00000006` | Number Of Actuations Tilt | unknown |
| `0x00000007` | Config Status | unknown |
| `0x00000008` | Current Position Lift Percentage | unknown |
| `0x00000009` | Current Position Tilt Percentage | unknown |
| `0x0000000A` | Operational Status | unknown |
| `0x0000000B` | Target Position Lift Percent100ths | unknown |
| `0x0000000C` | Target Position Tilt Percent100ths | unknown |
| `0x0000000D` | End Product Type | unknown |
| `0x0000000E` | Current Position Lift Percent100ths | unknown |
| `0x0000000F` | Current Position Tilt Percent100ths | unknown |
| `0x00000010` | Installed Open Limit Lift | unknown |
| `0x00000011` | Installed Closed Limit Lift | unknown |
| `0x00000012` | Installed Open Limit Tilt | unknown |
| `0x00000013` | Installed Closed Limit Tilt | unknown |
| `0x00000017` | Mode | unknown |
| `0x0000001A` | Safety Status | unknown |
| `0x0000FFF8` | Generated Command List | array |
| `0x0000FFF9` | Accepted Command List | array |
| `0x0000FFFA` | Event List | array |
| `0x0000FFFC` | Feature Map | unknown |
| `0x0000FFFD` | Cluster Revision | unknown |

### Commands

**Up Or Open** (`0x00`)

_No fields._

**Down Or Close** (`0x01`)

_No fields._

**Stop Motion** (`0x02`)

_No fields._

**Go To Lift Value** (`0x04`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | lift Value | unknown | no |

**Go To Lift Percentage** (`0x05`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | lift Percent100ths Value | unknown | no |

**Go To Tilt Value** (`0x07`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | tilt Value | unknown | no |

**Go To Tilt Percentage** (`0x08`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | tilt Percent100ths Value | unknown | no |

---

## Thermostat (0x00000201)

65 attributes, 8 commands.

### Attributes

| ID | Name | Type |
| --- | --- | --- |
| `0x00000000` | Local Temperature | unknown |
| `0x00000001` | Outdoor Temperature | unknown |
| `0x00000002` | Occupancy | unknown |
| `0x00000003` | Abs Min Heat Setpoint Limit | unknown |
| `0x00000004` | Abs Max Heat Setpoint Limit | unknown |
| `0x00000005` | Abs Min Cool Setpoint Limit | unknown |
| `0x00000006` | Abs Max Cool Setpoint Limit | unknown |
| `0x00000007` | PICooling Demand | unknown |
| `0x00000008` | PIHeating Demand | unknown |
| `0x00000009` | HVACSystem Type Configuration | unknown |
| `0x00000010` | Local Temperature Calibration | unknown |
| `0x00000011` | Occupied Cooling Setpoint | unknown |
| `0x00000012` | Occupied Heating Setpoint | unknown |
| `0x00000013` | Unoccupied Cooling Setpoint | unknown |
| `0x00000014` | Unoccupied Heating Setpoint | unknown |
| `0x00000015` | Min Heat Setpoint Limit | unknown |
| `0x00000016` | Max Heat Setpoint Limit | unknown |
| `0x00000017` | Min Cool Setpoint Limit | unknown |
| `0x00000018` | Max Cool Setpoint Limit | unknown |
| `0x00000019` | Min Setpoint Dead Band | unknown |
| `0x0000001A` | Remote Sensing | unknown |
| `0x0000001B` | Control Sequence Of Operation | unknown |
| `0x0000001C` | System Mode | unknown |
| `0x0000001E` | Thermostat Running Mode | unknown |
| `0x00000020` | Start Of Week | unknown |
| `0x00000021` | Number Of Weekly Transitions | unknown |
| `0x00000022` | Number Of Daily Transitions | unknown |
| `0x00000023` | Temperature Setpoint Hold | unknown |
| `0x00000024` | Temperature Setpoint Hold Duration | unknown |
| `0x00000025` | Thermostat Programming Operation Mode | unknown |
| `0x00000029` | Thermostat Running State | unknown |
| `0x00000030` | Setpoint Change Source | unknown |
| `0x00000031` | Setpoint Change Amount | unknown |
| `0x00000032` | Setpoint Change Source Timestamp | unknown |
| `0x00000034` | Occupied Setback | unknown |
| `0x00000035` | Occupied Setback Min | unknown |
| `0x00000036` | Occupied Setback Max | unknown |
| `0x00000037` | Unoccupied Setback | unknown |
| `0x00000038` | Unoccupied Setback Min | unknown |
| `0x00000039` | Unoccupied Setback Max | unknown |
| `0x0000003A` | Emergency Heat Delta | unknown |
| `0x00000040` | ACType | unknown |
| `0x00000041` | ACCapacity | unknown |
| `0x00000042` | ACRefrigerant Type | unknown |
| `0x00000043` | ACCompressor Type | unknown |
| `0x00000044` | ACError Code | unknown |
| `0x00000045` | ACLouver Position | unknown |
| `0x00000046` | ACCoil Temperature | unknown |
| `0x00000047` | ACCapacityformat | unknown |
| `0x00000048` | Preset Types | array |
| `0x00000049` | Schedule Types | array |
| `0x0000004A` | Number Of Presets | unknown |
| `0x0000004B` | Number Of Schedules | unknown |
| `0x0000004C` | Number Of Schedule Transitions | unknown |
| `0x0000004D` | Number Of Schedule Transition Per Day | unknown |
| `0x0000004E` | Active Preset Handle | octet string |
| `0x0000004F` | Active Schedule Handle | octet string |
| `0x00000050` | Presets | array |
| `0x00000051` | Schedules | array |
| `0x00000052` | Setpoint Hold Expiry Timestamp | unknown |
| `0x0000FFF8` | Generated Command List | array |
| `0x0000FFF9` | Accepted Command List | array |
| `0x0000FFFA` | Event List | array |
| `0x0000FFFC` | Feature Map | unknown |
| `0x0000FFFD` | Cluster Revision | unknown |

### Commands

**Get Weekly Schedule Response** (`0x00`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | number Of Transitions For Sequence | unknown | no |
| 1 | day Of Week For Sequence | unknown | no |
| 2 | mode For Sequence | unknown | no |
| 3 | transitions | array | no |

**Set Weekly Schedule** (`0x01`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | number Of Transitions For Sequence | unknown | no |
| 1 | day Of Week For Sequence | unknown | no |
| 2 | mode For Sequence | unknown | no |
| 3 | transitions | array | no |

**Get Weekly Schedule** (`0x02`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | days To Return | unknown | no |
| 1 | mode To Return | unknown | no |

**Clear Weekly Schedule** (`0x03`)

_No fields._

**Set Active Schedule Request** (`0x05`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | schedule Handle | octet string | no |

**Set Active Preset Request** (`0x06`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | preset Handle | octet string | yes |

**Atomic Response** (`0xFD`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | status Code | unknown | no |
| 1 | attribute Status | array | no |
| 2 | timeout | unknown | yes |

**Atomic Request** (`0xFE`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | request Type | unknown | no |
| 1 | attribute Requests | array | no |
| 2 | timeout | unknown | yes |

---

## Color Control (0x00000300)

57 attributes, 19 commands.

### Attributes

| ID | Name | Type |
| --- | --- | --- |
| `0x00000000` | Current Hue | unknown |
| `0x00000001` | Current Saturation | unknown |
| `0x00000002` | Remaining Time | unknown |
| `0x00000003` | Current X | unknown |
| `0x00000004` | Current Y | unknown |
| `0x00000005` | Drift Compensation | unknown |
| `0x00000006` | Compensation Text | string |
| `0x00000007` | Color Temperature Mireds | unknown |
| `0x00000008` | Color Mode | unknown |
| `0x0000000F` | Options | unknown |
| `0x00000010` | Number Of Primaries | unknown |
| `0x00000011` | Primary1 X | unknown |
| `0x00000012` | Primary1 Y | unknown |
| `0x00000013` | Primary1 Intensity | unknown |
| `0x00000015` | Primary2 X | unknown |
| `0x00000016` | Primary2 Y | unknown |
| `0x00000017` | Primary2 Intensity | unknown |
| `0x00000019` | Primary3 X | unknown |
| `0x0000001A` | Primary3 Y | unknown |
| `0x0000001B` | Primary3 Intensity | unknown |
| `0x00000020` | Primary4 X | unknown |
| `0x00000021` | Primary4 Y | unknown |
| `0x00000022` | Primary4 Intensity | unknown |
| `0x00000024` | Primary5 X | unknown |
| `0x00000025` | Primary5 Y | unknown |
| `0x00000026` | Primary5 Intensity | unknown |
| `0x00000028` | Primary6 X | unknown |
| `0x00000029` | Primary6 Y | unknown |
| `0x0000002A` | Primary6 Intensity | unknown |
| `0x00000030` | White Point X | unknown |
| `0x00000031` | White Point Y | unknown |
| `0x00000032` | Color Point RX | unknown |
| `0x00000033` | Color Point RY | unknown |
| `0x00000034` | Color Point RIntensity | unknown |
| `0x00000036` | Color Point GX | unknown |
| `0x00000037` | Color Point GY | unknown |
| `0x00000038` | Color Point GIntensity | unknown |
| `0x0000003A` | Color Point BX | unknown |
| `0x0000003B` | Color Point BY | unknown |
| `0x0000003C` | Color Point BIntensity | unknown |
| `0x00004000` | Enhanced Current Hue | unknown |
| `0x00004001` | Enhanced Color Mode | unknown |
| `0x00004002` | Color Loop Active | unknown |
| `0x00004003` | Color Loop Direction | unknown |
| `0x00004004` | Color Loop Time | unknown |
| `0x00004005` | Color Loop Start Enhanced Hue | unknown |
| `0x00004006` | Color Loop Stored Enhanced Hue | unknown |
| `0x0000400A` | Color Capabilities | unknown |
| `0x0000400B` | Color Temp Physical Min Mireds | unknown |
| `0x0000400C` | Color Temp Physical Max Mireds | unknown |
| `0x0000400D` | Couple Color Temp To Level Min Mireds | unknown |
| `0x00004010` | Start Up Color Temperature Mireds | unknown |
| `0x0000FFF8` | Generated Command List | array |
| `0x0000FFF9` | Accepted Command List | array |
| `0x0000FFFA` | Event List | array |
| `0x0000FFFC` | Feature Map | unknown |
| `0x0000FFFD` | Cluster Revision | unknown |

### Commands

**Move To Hue** (`0x00`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | hue | unknown | no |
| 1 | direction | unknown | no |
| 2 | transition Time | unknown | no |
| 3 | options Mask | unknown | no |
| 4 | options Override | unknown | no |

**Move Hue** (`0x01`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | move Mode | unknown | no |
| 1 | rate | unknown | no |
| 2 | options Mask | unknown | no |
| 3 | options Override | unknown | no |

**Step Hue** (`0x02`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | step Mode | unknown | no |
| 1 | step Size | unknown | no |
| 2 | transition Time | unknown | no |
| 3 | options Mask | unknown | no |
| 4 | options Override | unknown | no |

**Move To Saturation** (`0x03`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | saturation | unknown | no |
| 1 | transition Time | unknown | no |
| 2 | options Mask | unknown | no |
| 3 | options Override | unknown | no |

**Move Saturation** (`0x04`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | move Mode | unknown | no |
| 1 | rate | unknown | no |
| 2 | options Mask | unknown | no |
| 3 | options Override | unknown | no |

**Step Saturation** (`0x05`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | step Mode | unknown | no |
| 1 | step Size | unknown | no |
| 2 | transition Time | unknown | no |
| 3 | options Mask | unknown | no |
| 4 | options Override | unknown | no |

**Move To Hue And Saturation** (`0x06`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | hue | unknown | no |
| 1 | saturation | unknown | no |
| 2 | transition Time | unknown | no |
| 3 | options Mask | unknown | no |
| 4 | options Override | unknown | no |

**Move To Color** (`0x07`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | color X | unknown | no |
| 1 | color Y | unknown | no |
| 2 | transition Time | unknown | no |
| 3 | options Mask | unknown | no |
| 4 | options Override | unknown | no |

**Move Color** (`0x08`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | rate X | unknown | no |
| 1 | rate Y | unknown | no |
| 2 | options Mask | unknown | no |
| 3 | options Override | unknown | no |

**Step Color** (`0x09`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | step X | unknown | no |
| 1 | step Y | unknown | no |
| 2 | transition Time | unknown | no |
| 3 | options Mask | unknown | no |
| 4 | options Override | unknown | no |

**Move To Color Temperature** (`0x0A`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | color Temperature Mireds | unknown | no |
| 1 | transition Time | unknown | no |
| 2 | options Mask | unknown | no |
| 3 | options Override | unknown | no |

**Enhanced Move To Hue** (`0x40`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | enhanced Hue | unknown | no |
| 1 | direction | unknown | no |
| 2 | transition Time | unknown | no |
| 3 | options Mask | unknown | no |
| 4 | options Override | unknown | no |

**Enhanced Move Hue** (`0x41`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | move Mode | unknown | no |
| 1 | rate | unknown | no |
| 2 | options Mask | unknown | no |
| 3 | options Override | unknown | no |

**Enhanced Step Hue** (`0x42`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | step Mode | unknown | no |
| 1 | step Size | unknown | no |
| 2 | transition Time | unknown | no |
| 3 | options Mask | unknown | no |
| 4 | options Override | unknown | no |

**Enhanced Move To Hue And Saturation** (`0x43`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | enhanced Hue | unknown | no |
| 1 | saturation | unknown | no |
| 2 | transition Time | unknown | no |
| 3 | options Mask | unknown | no |
| 4 | options Override | unknown | no |

**Color Loop Set** (`0x44`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | update Flags | unknown | no |
| 1 | action | unknown | no |
| 2 | direction | unknown | no |
| 3 | time | unknown | no |
| 4 | start Hue | unknown | no |
| 5 | options Mask | unknown | no |
| 6 | options Override | unknown | no |

**Stop Move Step** (`0x47`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | options Mask | unknown | no |
| 1 | options Override | unknown | no |

**Move Color Temperature** (`0x4B`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | move Mode | unknown | no |
| 1 | rate | unknown | no |
| 2 | color Temperature Minimum Mireds | unknown | no |
| 3 | color Temperature Maximum Mireds | unknown | no |
| 4 | options Mask | unknown | no |
| 5 | options Override | unknown | no |

**Step Color Temperature** (`0x4C`)

| Tag | Field | Type | Nullable |
| --- | --- | --- | :---: |
| 0 | step Mode | unknown | no |
| 1 | step Size | unknown | no |
| 2 | transition Time | unknown | no |
| 3 | color Temperature Minimum Mireds | unknown | no |
| 4 | color Temperature Maximum Mireds | unknown | no |
| 5 | options Mask | unknown | no |
| 6 | options Override | unknown | no |

---

## Illuminance Measurement (0x00000400)

10 attributes, 0 commands.

### Attributes

| ID | Name | Type |
| --- | --- | --- |
| `0x00000000` | Measured Value | unknown |
| `0x00000001` | Min Measured Value | unknown |
| `0x00000002` | Max Measured Value | unknown |
| `0x00000003` | Tolerance | unknown |
| `0x00000004` | Light Sensor Type | unknown |
| `0x0000FFF8` | Generated Command List | array |
| `0x0000FFF9` | Accepted Command List | array |
| `0x0000FFFA` | Event List | array |
| `0x0000FFFC` | Feature Map | unknown |
| `0x0000FFFD` | Cluster Revision | unknown |

### Commands

_No commands cataloged._
---

## Temperature Measurement (0x00000402)

9 attributes, 0 commands.

### Attributes

| ID | Name | Type |
| --- | --- | --- |
| `0x00000000` | Measured Value | unknown |
| `0x00000001` | Min Measured Value | unknown |
| `0x00000002` | Max Measured Value | unknown |
| `0x00000003` | Tolerance | unknown |
| `0x0000FFF8` | Generated Command List | array |
| `0x0000FFF9` | Accepted Command List | array |
| `0x0000FFFA` | Event List | array |
| `0x0000FFFC` | Feature Map | unknown |
| `0x0000FFFD` | Cluster Revision | unknown |

### Commands

_No commands cataloged._
---

## Pressure Measurement (0x00000403)

14 attributes, 0 commands.

### Attributes

| ID | Name | Type |
| --- | --- | --- |
| `0x00000000` | Measured Value | unknown |
| `0x00000001` | Min Measured Value | unknown |
| `0x00000002` | Max Measured Value | unknown |
| `0x00000003` | Tolerance | unknown |
| `0x00000010` | Scaled Value | unknown |
| `0x00000011` | Min Scaled Value | unknown |
| `0x00000012` | Max Scaled Value | unknown |
| `0x00000013` | Scaled Tolerance | unknown |
| `0x00000014` | Scale | unknown |
| `0x0000FFF8` | Generated Command List | array |
| `0x0000FFF9` | Accepted Command List | array |
| `0x0000FFFA` | Event List | array |
| `0x0000FFFC` | Feature Map | unknown |
| `0x0000FFFD` | Cluster Revision | unknown |

### Commands

_No commands cataloged._
---

## Flow Measurement (0x00000404)

9 attributes, 0 commands.

### Attributes

| ID | Name | Type |
| --- | --- | --- |
| `0x00000000` | Measured Value | unknown |
| `0x00000001` | Min Measured Value | unknown |
| `0x00000002` | Max Measured Value | unknown |
| `0x00000003` | Tolerance | unknown |
| `0x0000FFF8` | Generated Command List | array |
| `0x0000FFF9` | Accepted Command List | array |
| `0x0000FFFA` | Event List | array |
| `0x0000FFFC` | Feature Map | unknown |
| `0x0000FFFD` | Cluster Revision | unknown |

### Commands

_No commands cataloged._
---

## Relative Humidity Measurement (0x00000405)

9 attributes, 0 commands.

### Attributes

| ID | Name | Type |
| --- | --- | --- |
| `0x00000000` | Measured Value | unknown |
| `0x00000001` | Min Measured Value | unknown |
| `0x00000002` | Max Measured Value | unknown |
| `0x00000003` | Tolerance | unknown |
| `0x0000FFF8` | Generated Command List | array |
| `0x0000FFF9` | Accepted Command List | array |
| `0x0000FFFA` | Event List | array |
| `0x0000FFFC` | Feature Map | unknown |
| `0x0000FFFD` | Cluster Revision | unknown |

### Commands

_No commands cataloged._
---

## Occupancy Sensing (0x00000406)

19 attributes, 0 commands.

### Attributes

| ID | Name | Type |
| --- | --- | --- |
| `0x00000000` | Occupancy | unknown |
| `0x00000001` | Occupancy Sensor Type | unknown |
| `0x00000002` | Occupancy Sensor Type Bitmap | unknown |
| `0x00000003` | Hold Time | unknown |
| `0x00000004` | Hold Time Limits | struct |
| `0x00000010` | PIROccupied To Unoccupied Delay | unknown |
| `0x00000011` | PIRUnoccupied To Occupied Delay | unknown |
| `0x00000012` | PIRUnoccupied To Occupied Threshold | unknown |
| `0x00000020` | Ultrasonic Occupied To Unoccupied Delay | unknown |
| `0x00000021` | Ultrasonic Unoccupied To Occupied Delay | unknown |
| `0x00000022` | Ultrasonic Unoccupied To Occupied Threshold | unknown |
| `0x00000030` | Physical Contact Occupied To Unoccupied Delay | unknown |
| `0x00000031` | Physical Contact Unoccupied To Occupied Delay | unknown |
| `0x00000032` | Physical Contact Unoccupied To Occupied Threshold | unknown |
| `0x0000FFF8` | Generated Command List | array |
| `0x0000FFF9` | Accepted Command List | array |
| `0x0000FFFA` | Event List | array |
| `0x0000FFFC` | Feature Map | unknown |
| `0x0000FFFD` | Cluster Revision | unknown |

### Commands

_No commands cataloged._
---

