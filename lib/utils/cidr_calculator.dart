import 'dart:math';

///
/// [CidrCalculator] can be used to fetch summary information for CIDR address like "192.168.0.2/22".
///
class CidrCalculator {
  final String cidr;
  int _maskLength;
  String _maskCode;
  String _ip;
  String _networkId;
  String _networkBroadcast;
  String _firstHost;
  String _lastHost;
  int _available;

  String get ip => _ip;
  String get maskCode => _maskCode;
  String get networkID => _networkId;
  String get networkBroadcast => _networkBroadcast;
  String get firstHost => _firstHost;
  String get lastHost => _lastHost;
  int get available => _available;

  CidrCalculator({this.cidr}) : assert(cidr != null) {
    this._init();
  }

  void _init() {
    const String pattern =
        r'^(?:(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\/([1-9]|[1-2]\d|3[0-2])$';
    if (!RegExp(pattern).hasMatch(cidr)) {
      throw Exception("CIDR $cidr is invalid.");
    } else {
      this.parseCidr();
    }
  }

  void parseCidr() {
    String getMaskCodeFromMaskLength(int length) {
      String maskBinary = '1' * _maskLength + '0' * (32 - _maskLength);
      return int.parse(maskBinary.substring(0, 8), radix: 2).toString() +
          '.' +
          int.parse(maskBinary.substring(8, 16), radix: 2).toString() +
          '.' +
          int.parse(maskBinary.substring(16, 24), radix: 2).toString() +
          '.' +
          int.parse(maskBinary.substring(24, 32), radix: 2).toString();
    }

    List<String> splitAddress(String ipAddress) {
      return ipAddress.split(r'.');
    }

    List<String> convertToBinaryArray(List<String> array) {
      for (int i = 0; i < array.length; i++) {
        array[i] = (int.parse(array[i]) + 256).toRadixString(2).substring(1);
      }
      return array;
    }

    String getNetworkId() {
      List<String> ipArr = splitAddress(_ip);
      List<String> maskArr = splitAddress(_maskCode);
      List<String> networkArr = List(4);
      for (int i = 0; i < 4; i++) {
        networkArr[i] = (int.parse(ipArr[i]) & int.parse(maskArr[i])).toString();
      }
      String networkId = networkArr.join('.');

      return networkId;
    }

    String getNetworkBroadcast() {
      List<String> maskArr = splitAddress(_maskCode);
      List<String> networkIdArr = splitAddress(_networkId);
      String maskBinaryString = convertToBinaryArray(maskArr).join(r'.');
      int hostIndexOfMask = maskBinaryString.indexOf(r'0');
      String networkIdBinaryString = convertToBinaryArray(networkIdArr).join(r'.');
      String netAddressOfNetwork = networkIdBinaryString.substring(0, hostIndexOfMask);
      String hostOfNetwork = networkIdBinaryString.substring(hostIndexOfMask, networkIdBinaryString.length).replaceAll(RegExp(r'\d'), '1');
      List<String> broadcastStringArr = (netAddressOfNetwork + hostOfNetwork).split(r'.');
      for (int i = 0; i < 4; i++) {
        broadcastStringArr[i] = int.parse(broadcastStringArr[i], radix: 2).toString();
      }
      return broadcastStringArr.join(r'.');
    }

    String getNetworkStart() {
      List<String> networkIdArr = splitAddress(_networkId);
      networkIdArr[3] = (int.parse(networkIdArr[3]) + 1).toString();
      return networkIdArr.join('.');
    }

    String getNetworkEnd() {
      List<String> broadcastArr = splitAddress(_networkBroadcast);
      broadcastArr[3] = (int.parse(broadcastArr[3]) - 1).toString();
      return broadcastArr.join('.');
    }

    _maskLength = int.parse(cidr.substring(cidr.indexOf(r'/') + 1));
    _ip = cidr.substring(0, cidr.indexOf(r'/'));
    _maskCode = getMaskCodeFromMaskLength(_maskLength);
    _networkId = getNetworkId();
    _networkBroadcast = getNetworkBroadcast();
    _firstHost = getNetworkStart();
    _lastHost = getNetworkEnd();
    _available = pow(2, 32 - _maskLength) - 2;
  }
}
