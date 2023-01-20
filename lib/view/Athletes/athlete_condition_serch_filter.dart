import 'package:collection/collection.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pachub/common_widget/TextField.dart';
import 'package:pachub/common_widget/textstyle.dart';
import 'package:pachub/config/preference.dart';
import '../../Utils/appcolors.dart';


////// TODO Count wise Conditionfilter ////////////


class AthleteConditionSerchfilter extends StatefulWidget {
  final int? index;
  final bool? isaddtap;
  final Function addTap;
  final Function closeTap;
  final List filedPlayedList;
  final List selectedVlue;
  final TextEditingController value;
  final List position;
  final int? counter;
  final String id;
  String? conditionValue;

  AthleteConditionSerchfilter(
      {Key? key,
      this.index,
      this.isaddtap,
      required this.addTap,
      required this.closeTap,
      required this.filedPlayedList,
      required this.selectedVlue,
      required this.value,
      required this.position,
      this.counter,
      required this.id, this.conditionValue, String? fieldValue})
      : super(key: key);

  @override
  State<AthleteConditionSerchfilter> createState() => _AthleteConditionSerchfilterState();
}

class _AthleteConditionSerchfilterState extends State<AthleteConditionSerchfilter> {
  List<String> itemsCondition_dropdown = [
    'Equals',
    'Not Equals',
    'Less Equal',
    'Grater Equal',
  ];
  TextEditingController Search_Value_Controller = TextEditingController();

  String? search_condition_selected_value;
  String? newselectedpostion;
  List newpostionselected_multiplevalue_list = [];
  String? search_field_default_seletected_value;
  var seen = Set<String>();
  List position = [];
  List list = [];
  var group;
  var group2;

  @override
  void initState() {
    group2 = groupBy(widget.filedPlayedList, (e) => e["name"]).map((key, value) => MapEntry(key, value.map((e) => e).whereNotNull().toList()));
    group = groupBy(widget.filedPlayedList, (e) => e["id"]).map((key, value) => MapEntry(key, value.map((e) => e["displayName"]).whereNotNull().toList()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("SelectedValue ==========>>>>  ${group2}");
    print("SelectedPosition ==========>>>>  ${widget.position}");
    print("SelectedpositionList ==========>>>>  ${position}");
    position.length = 0;
    widget.position.forEach((element) => {
          print("element ===== >  $element"),
          print("this.group2[element] ${this.group2[element]}"),
          list = this.group2[element],
          print("list ===== >  $list"),
          list.forEach((field) {
            position.add(field);
          }),
        });
    return Column(
      children: [
        search_field_default_Dropdown(position),
        SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          search_condition_Dropdown(),
          textfield_search_value(),
          outlinebutton_search_add(widget.index),
        ]),
      ],
    );
  }

  Widget search_condition_Dropdown() {
    return StatefulBuilder(builder: (context, setState) {
      return Container(
          height: 46,
          width: 120,
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(
              color: AppColors.grey_hint_color,
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              itemPadding: const EdgeInsets.only(left: 14, right: 14),
              dropdownMaxHeight: 200,
              dropdownWidth: 150,
              dropdownPadding: null,
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.white,
              ),
              value: search_condition_selected_value,
              underline: Container(),
              isExpanded: true,
              //itemHeight: 50.0,
              icon: const Icon(Icons.keyboard_arrow_down,
                  size: 25, color: AppColors.grey_text_color),
              style: TextStyle(fontSize: 15.0, color: Colors.grey[700]),
              items: itemsCondition_dropdown.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: CommonText(
                      text: item,
                      fontSize: 13,
                      color: AppColors.black,
                      fontWeight: FontWeight.w500),
                );
              }).toList(),
              hint: const CommonText(
                  text: "Condition",
                  fontSize: 13,
                  color: AppColors.black,
                  fontWeight: FontWeight.w500),
              onChanged: (String? newValue) {
                setState(() => search_condition_selected_value = newValue);
                // widget.cartItem.itemName = value;
                // setState(() => search_condition_selected_value = newValue);
                if (kDebugMode) {
                  print(
                      "condition Search ====> ${search_condition_selected_value}");
                  PreferenceUtils.setString("conditionValue", search_condition_selected_value.toString());
                }
              },
            ),
          ));
    });
  }

  Widget textfield_search_value() {
    return Container(
      width: 120,
      child: TextFieldView(
        controller: Search_Value_Controller,
        textInputAction: TextInputAction.next,
        type: TextInputType.number,
        onChanged: (value) => {
          if (kDebugMode)
            {
              print("value Search ====> ${value}"),
              PreferenceUtils.setString("value", value),
            }
        },
        text: "value",
      ),
    );
  }

  Widget outlinebutton_search_add(countIndex) {
    return Card(
      shape: RoundedRectangleBorder(
          side: BorderSide(
              width: 1,
              color: widget.isaddtap!
                  ? AppColors.dark_blue_button_color
                  : AppColors.dark_red),
          borderRadius: BorderRadius.circular(10)),
      child: widget.isaddtap!
          ? IconButton(
              iconSize: 15,
              icon: const Icon(
                Icons.add,
                color: AppColors.dark_blue_button_color,
              ),
              onPressed: () {
                setState(
                  () {
                    //count++;
                    widget.isaddtap == true;
                    widget.counter;
                    widget.addTap(widget.id);
                  },
                );
              },
            )
          : IconButton(
              iconSize: 15,
              icon: const Icon(
                Icons.close,
                color: AppColors.dark_red,
              ),
              onPressed: () {
                setState(
                  () {
                    //count++;
                    widget.isaddtap == true;
                    widget.counter;
                    widget.closeTap(widget.counter);
                  },
                );
              },
            ),
    );
  }

  Widget search_field_default_Dropdown(List itemList) {
    print("widget.filedPlayedList ${widget.filedPlayedList}");
    return StatefulBuilder(builder: (context, setState) {
      return Container(
          height: 46,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(
              color: AppColors.grey_hint_color,
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              itemPadding: const EdgeInsets.only(left: 14, right: 14),
              dropdownMaxHeight: 200,
              dropdownWidth: 200,
              dropdownPadding: null,
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.white,
              ),
              value: search_field_default_seletected_value,
              underline: Container(),
              isExpanded: true,
              //itemHeight: 50.0,
              icon: Icon(Icons.keyboard_arrow_down,
                  size: 25, color: AppColors.grey_text_color),
              style: TextStyle(fontSize: 15.0, color: Colors.grey[700]),
              items: itemList.map((item) {
                return DropdownMenuItem(
                  value: item["displayName"].toString(),
                  child: CommonText(
                      text: item["displayName"].toString(),
                      fontSize: 13,
                      color: AppColors.black,
                      fontWeight: FontWeight.w500),
                );
              }).toList(),
              hint: const CommonText(
                  text: "Field",
                  fontSize: 13,
                  color: AppColors.black,
                  fontWeight: FontWeight.w500),
              onChanged: (String? newValue) {
                setState(
                    () => search_field_default_seletected_value = newValue);
                PreferenceUtils.setString(
                    "filedName", search_field_default_seletected_value ?? "");
                if (kDebugMode) {
                  print(
                      "filed value ====>>> ${search_field_default_seletected_value.toString()}");
                }
              },
            ),
          ));
    });
  }
}