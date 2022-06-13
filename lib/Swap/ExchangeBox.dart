import 'package:acy_ipay/Swap/button_token_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:acy_ipay/Swap/button_max_token.dart';
import 'dart:math' as math;

class ExchangeBox extends StatefulWidget {
  final bool needMax;
  const ExchangeBox({Key? key, required this.needMax}) : super(key: key);

  @override
  State<ExchangeBox> createState() => _ExchangeBoxState();
}

class NumberRemoveExtraDotFormatter extends TextInputFormatter {
  NumberRemoveExtraDotFormatter({this.decimalRange = 3})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String nValue = newValue.text;
    TextSelection nSelection = newValue.selection;

    Pattern p = RegExp(r'(\d+\.?)|(\.?\d+)|(\.?)');
    nValue = p
        .allMatches(nValue)
        .map<String>((Match match) => match.group(0).toString())
        .join();

    if (nValue.startsWith('.')) {
      nValue = '0.';
    } else if (nValue.contains('.')) {
      if (nValue.substring(nValue.indexOf('.') + 1).length > decimalRange) {
        nValue = oldValue.text;
      } else {
        if (nValue.split('.').length > 2) {
          List<String> split = nValue.split('.');
          nValue = split[0] + '.' + split[1];
        }
      }
    }

    nSelection = newValue.selection.copyWith(
      baseOffset: math.min(nValue.length, nValue.length + 1),
      extentOffset: math.min(nValue.length, nValue.length + 1),
    );

    return TextEditingValue(
        text: nValue, selection: nSelection, composing: TextRange.empty);
  }
}

class _ExchangeBoxState extends State<ExchangeBox> {
  TextEditingController tokenAmount = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints.tightFor(width: 220, height: 45),
            child: TextField(
              controller: tokenAmount,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                NumberRemoveExtraDotFormatter()
                //BlacklistingTextInputFormatter(new RegExp('[\\-|\\ ]')),
                //WhitelistingTextInputFormatter(new RegExp('^\d+[\.\,]\d+\$')),
              ],
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(12, 0, 0, 6),
                  hintText: "0",
                  hintStyle: TextStyle(fontWeight: FontWeight.w400),
                  border: InputBorder.none
                  //border: OutlineInputBorder(),
                  ),
              style: TextStyle(
                fontFamily: 'Karla',
                fontWeight: FontWeight.w300,
                fontSize: 18,
              ),
            ),
          ),
          widget.needMax
              ? MaxToken()
              : SizedBox(
                  height: 25,
                  width: 40,
                ),
          TokenSelect(),
        ],
      ),
    );
  }
}
