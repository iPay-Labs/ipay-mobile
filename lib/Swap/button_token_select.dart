import 'package:acy_ipay/Constant/token_data.dart';
import 'package:acy_ipay/widget/search_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Model/token.dart';

class TokenSelect extends StatefulWidget {
  const TokenSelect({Key? key}) : super(key: key);

  @override
  State<TokenSelect> createState() => _TokenSelectState();
}

class _TokenSelectState extends State<TokenSelect> {
  late List<Token> resTokens;
  String query = '';

  @override
  void initState() {
    super.initState();
    resTokens = tokenList;
  }

  void searchToken(String userInput) {
    final filteredTokens = tokenList.where((token) {
      // TO-DO: Add search using token address
      final symbolLower = token.symbol.toLowerCase(); // Search using symbol
      final nameLower = token.name.toLowerCase(); // Search using name
      final searchLower = userInput.toLowerCase();

      return symbolLower.contains(searchLower) ||
          nameLower.contains(searchLower);
    }).toList();

    setState(() {
      query = userInput;
      resTokens = filteredTokens;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget buildToken(Token token) => ListTile(
          leading: Padding(
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: SizedBox(
              height: 32,
              width: 32,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset(
                      token.assetPath,
                      height: 30,
                      width: 30,
                    ),
                  ]),
            ),
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                token.symbol,
                style: TextStyle(
                    fontFamily: 'Karla',
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: Colors.black),
              ),
              Text(
                token.name,
                style: TextStyle(
                    fontFamily: 'Karla',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Colors.grey.shade500),
              ),
            ],
          ),
          trailing: Text(
            "0.25",
            style: TextStyle(
                fontFamily: 'Karla',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.black), //
          ),
        );

    return TextButton(
        onPressed: () async {
          showModalBottomSheet(
              enableDrag: false,
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              isScrollControlled: true,
              //isDismissible: true,
              //backgroundColor: Colors.white,
              builder: (BuildContext context) {
                return DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: 0.8,
                  minChildSize: 0.71,
                  maxChildSize: 0.8,
                  builder: (context, scrollController) {
                    return Column(
                      children: <Widget>[
                        SearchWidget(
                            text: query,
                            onChanged: searchToken,
                            hintText: "Enter name or paste address"),
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: resTokens.length,
                            shrinkWrap: true,
                            itemBuilder: (context, int index) {
                              final token = resTokens[index];
                              return buildToken(token);
                            },
                          ),
                        )
                      ],
                    );
                  },
                );
              });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "BTC",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Karla',
                  fontWeight: FontWeight.w500),
            ),
            SvgPicture.asset(
              "assets/icon/icon_expand.svg",
              height: 20,
              width: 15,
              color: Colors.black,
            )
          ],
        ));
  }
}
