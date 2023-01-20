import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:uuid/uuid.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:pachub/Utils/appcolors.dart';
import 'package:pachub/Utils/appstring.dart';
import 'package:pachub/Utils/images.dart';
import 'package:pachub/common_widget/TextField.dart';
import 'package:pachub/common_widget/appbar.dart';
import 'package:pachub/view/Athletes/athlete_condition_serch_filter.dart';
import 'package:pachub/common_widget/customloader.dart';
import 'package:pachub/common_widget/textstyle.dart';
import 'package:pachub/config/preference.dart';
import 'package:pachub/models/Profile_model.dart';
import 'package:pachub/models/admin_athletes_model.dart';
import 'package:pachub/models/bookmark_model.dart';
import 'package:pachub/models/coach_athelete_model.dart';
import 'package:pachub/models/coach_athelete_search.dart';
import 'package:pachub/services/request.dart';
import 'package:pachub/view/dashboard/homescreen.dart';
import 'package:pachub/view/login/login_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:readmore/readmore.dart';
import 'package:http/http.dart' as http;

import '../../Utils/constant.dart';
import '../../app_function/MyAppFunction.dart';
import '../../common_widget/bottom_bar.dart';
import '../../common_widget/button.dart';
import '../../common_widget/nodatafound_page.dart';
import '../../models/admin_recruiter_model.dart';
import '../../models/stats_model.dart';
import '../dashboard/tab_deatil_screen.dart';

class Athletes extends StatefulWidget {
  const Athletes({Key? key}) : super(key: key);

  @override
  State<Athletes> createState() => _AthletesState();
}

class _AthletesState extends State<Athletes> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController();
  TextEditingController playerController = TextEditingController();
  TextEditingController SendMessageController = TextEditingController();
  TextEditingController plyeridController = TextEditingController();
  TextEditingController approvalCommentController = TextEditingController();
  TextEditingController Search_Value_Controller = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController searchcontroller = TextEditingController();
  VoidCallback? callback;
  String? search_position_selecte_value;
  String? search_field_seletected_value;
  String? search_field_default_seletected_value;
  String? search_field_other_seletected_value;
  String? search_condition_selected_value;
  String? conditionAdd;
  String? status_dropdown_value = "All";
  String searchString = "";
  DateTime? startDate;
  DateTime? endDate;
  String? stDate;
  String? edDate;
  var athleteuserdetails = {};
  String? userId;
  String? clientTrainerID;
  bool isaddtap = false;
  var counter = 0;
  List search_additional_counter_list = [0];
  int cIndex = 0;
  bool update_drop_downvalue_afterselect = false;
  late String _localPath;
  late bool _permissionReady;
  late TargetPlatform? platform;
  bool applybuttonvalue = false;
  bool clearbuttonvalue = false;
  List<Record> Admin_clgListModel = [];
  bool _isFirstLoadRunning = false;
  List Admin_clglist = [];
  int _page = 0;
  final int _limit = 30;
  String? value = "IF";
  List newpostionselected_multiplevalue_list = [];
  var newpostionselected_multiplevalue;
  List request_newpostionselected_multiplevalue_list = [];
  Map? dataItem;
  List paramsItem = [];
  var models = <String>{};
  List uniquelist = [];
  List itemList = [];
  List itemData = [];
  var isDataLoading = false.obs;
  bool? isbookmarkclick = false;
  bool _isChecked_Interested_INMyCollege = false;
  var positionPlayed;
  var position;
  var seen = Set<String>();
  var veen = Set<String>();
  List positionPlayedList = [];
  List filedPlayedList = [];
  var group;
  String? newselectedpostion;
  List selectSportsResult = [];
  List allSports = [{'name': "All Sports", 'id': 0}];
  List allSportsList = [];
  final List<String> itemsStatus_dropdown = [
    'All',
    'Approved',
    'Rejected',
    'Pending',
  ];
  final List<String> itemsPosition_dropdown = [
    'Pitcher',
    'In Field',
    'Out Field',
    'Catcher',
    'Universal',
  ];

  final List<String> itemsCondition_dropdown = [
    'Equals',
    'Not Equals',
    'Less Equal',
    'Grater Equal',
  ];
  final List<String> itemsField_if_Pitcher_selected_dropdown = [
    "THROWS",
    "SO",
    "BB",
    "ERA",
    "IP",
  ];
  final List<String> itemsField_if_othervalue_selected_dropdown = [
    "THROWS",
    "SO",
    "BB",
    "BATS",
    "AVG",
    "HITS",
  ];
  final List<String> itemsfield_multiple_selected_dropdown = [
    "THROWS",
    "SO",
    "BB",
    "ERA",
    "IP",
    "BATS",
    "AVG",
    "HITS",
  ];

  @override
  void dispose() {
    playerController.dispose();
    SendMessageController.dispose();
    dateController.dispose();
    _isChecked_Interested_INMyCollege == false;
    super.dispose();
  }

  String? accessToken;
  String? dropDownValue;
  List Coach_Athleteslist = [];
  List Coach_athelete_search_list = [];
  List<CoachAteleteResult> Coach_AthletesModel = [];
  List Coach_STATS_Model = [];
  List<DataSearch> Coach_Athletes_Search_Model = [];
  List? trainerList;
  String? trainer;
  List athleteItemList = [];
  Map item = {};
  String? roleName;
  bool isSelected = false;
  String? selectSportsDropDownValue;

  Future getTrainerList(String? clientID) async {
    await http.post(
      Uri.parse(AppConstant.TRAINER_USERS),
      body: {"clientID": clientID},
      headers: {"Authorization": "Bearer $accessToken"},
    ).then((response) {
      var data = json.decode(response.body);
      setState(() {
        trainerList = data['trainer'];
      });
    });
  }

  @override
  void initState() {
    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }
    setState(() {
      accessToken = PreferenceUtils.getString("accesstoken");
      userId = PreferenceUtils.getInt("userid").toString();
      roleName = PreferenceUtils.getString("role");
      print("token data ========>>> $accessToken");
    });
    super.initState();
    getTrainerList("1");
    SelcteSportsList();
    Admmingetcollegerecruiters(stDate, edDate);
    Coach_athletes_getlist();
    serach_filter_api();
    getAthleteListApi(accessToken, _page, _limit, "2");

    // COACH_SEARCH_ATHELETE(request_newpostionselected_multiplevalue_list,
    //     conditionAdd ?? "", Search_Value_Controller.text);
  }

/////////////////TODO CHECK permission for downaload transcript///////////////////////////////
  Future<bool> _checkPermission() async {
    if (platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;

    print(_localPath);
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    if (platform == TargetPlatform.android) {
      return "/sdcard/download/";
    } else {
      var directory = await getApplicationDocumentsDirectory();
      return directory.path + Platform.pathSeparator + 'Download';
    }
  }

  late final Future myFutureList =  getAthleteListApi(accessToken, _page, _limit, "2");



  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      edgeOffset: 20,
      onRefresh: () async {
        await Future.delayed(Duration(milliseconds: 1500));
        setState(() {
          getTrainerList("1");
          Admmingetcollegerecruiters(stDate, edDate);
          Coach_athletes_getlist();
          SelcteSportsList();
          getAthleteListApi(accessToken, _page, _limit, "2");
          COACH_SEARCH_ATHELETE(request_newpostionselected_multiplevalue_list,
              conditionAdd ?? "", Search_Value_Controller.text);
        });
      },
      child: Scaffold(
        appBar: Appbar(
          text: AppString.athletesName,
          onClick: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        drawer: const Drawer(),
        body: PreferenceUtils.getString("role") == "admin"
            ? showlistrolewise()
            : PreferenceUtils.getString("plan_login") == "Free"
                ? Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        BottomBar(selectedIndex: 6)));
                          },
                          child: CommonText(
                              text: "Upgrade",
                              fontSize: 15,
                              color: AppColors.dark_blue_button_color,
                              fontWeight: FontWeight.w600),
                        ),
                        CommonText(
                            text: "Your Subscription ToView More Information.",
                            fontSize: 15,
                            color: AppColors.black_txcolor,
                            fontWeight: FontWeight.w400),
                      ],
                    ),
                  )
                : showlistrolewise(),
      ),
    );
  }

  Widget Adminathleterole() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(top: 0),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.grey_hint_color),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                searchString = value.toLowerCase();
                              });
                            },
                            onEditingComplete: () {},
                            controller: searchcontroller,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 10, bottom: 5),
                              border: InputBorder.none,
                              hintText: "Search",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Container(
                    height: 45,
                    width: 120,
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      color: AppColors.white,
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
                        value: status_dropdown_value,
                        underline: Container(),
                        isExpanded: true,
                        //itemHeight: 50.0,
                        icon: Icon(Icons.keyboard_arrow_down,
                            size: 25, color: AppColors.grey_text_color),
                        style:
                            TextStyle(fontSize: 15.0, color: Colors.grey[700]),
                        items: itemsStatus_dropdown.map((item) {
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
                            text: "All",
                            fontSize: 15,
                            color: AppColors.black,
                            fontWeight: FontWeight.w500),
                        onChanged: (newValue) {
                          setState(() => status_dropdown_value = newValue);
                          if (kDebugMode) {
                            print(
                                "this is serach postion selected==> $status_dropdown_value");
                          }
                        },
                      ),
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(top: 0),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.grey_hint_color),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: dateController,
                            readOnly: true,
                            onTap: () {
                              showCustomDateRangePicker(
                                context,
                                dismissible: true,
                                minimumDate: DateTime.now()
                                    .subtract(const Duration(days: 365)),
                                maximumDate: DateTime.now()
                                    .add(const Duration(days: 365)),
                                endDate: endDate,
                                startDate: startDate,
                                onApplyClick: (start, end) {
                                  setState(() {
                                    endDate = end;
                                    startDate = start;
                                  });
                                  setState(() {
                                    dateController.text =
                                        '${startDate != null ? DateFormat("yMMMMd").format(startDate!) : '-'} to ${endDate != null ? DateFormat("yMMMMd").format(endDate!) : '-'}';
                                    stDate = startDate != null
                                        ? DateFormat("yyyy-MM-dd")
                                            .format(startDate!)
                                        : '-';
                                    edDate = startDate != null
                                        ? DateFormat("yyyy-MM-dd")
                                            .format(endDate!)
                                        : '-';
                                    Admmingetcollegerecruiters(stDate, edDate);
                                    print("stDate =====>> $stDate");
                                    print("edDate =====>> $edDate");
                                  });
                                },
                                onCancelClick: () {
                                  setState(() {
                                    endDate = null;
                                    startDate = null;
                                  });
                                  setState(() {
                                    dateController.text = "";
                                  });
                                },
                              );
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 10, bottom: 5),
                              border: InputBorder.none,
                              hintText: "Search by date range",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                searchcontroller.text.isEmpty &&
                        status_dropdown_value == "All" &&
                        dateController.text.isEmpty
                    ? Container()
                    : SizedBox(width: 15),
                searchcontroller.text.isEmpty &&
                        status_dropdown_value == "All" &&
                        dateController.text.isEmpty
                    ? Container()
                    : OutlinedButton(
                        child: const CommonText(
                          text: "Clear",
                          fontSize: 14,
                          color: AppColors.dark_red,
                          fontWeight: FontWeight.w400,
                        ),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)),
                          side:
                              BorderSide(width: 1.0, color: AppColors.dark_red),
                        ),
                        onPressed: () {
                          setState(() {
                            searchcontroller.clear();
                            status_dropdown_value = "All";
                            dateController.clear();
                          });
                        }

                        /*Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const NewScreen())),*/
                        ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  color: AppColors.white,
                  border: Border.all(
                    color: AppColors.grey_hint_color,
                    width: 1,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    itemPadding: const EdgeInsets.only(left: 14, right: 14),
                    dropdownMaxHeight: 200,
                    dropdownWidth: 180,
                    dropdownPadding: null,
                    dropdownDecoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(14),
                      color: Colors.white,
                    ),
                    value: selectSportsDropDownValue,
                    underline: Container(),
                    isExpanded: true,
                    itemHeight: 35.0,
                    style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey[700]),
                    items: allSportsList.map((item) {
                      return DropdownMenuItem(
                        value: item["name"].toString(),
                        child: CommonText(
                            text: item["name"].toString(),
                            fontSize: 14,
                            color: AppColors.black,
                            fontWeight: FontWeight.w500),
                      );
                    }).toList(),
                    hint: const CommonText(
                        text: "All Sports",
                        fontSize: 14,
                        color: AppColors.black,
                        fontWeight: FontWeight.w500),
                    onChanged:
                        (newValue) {
                      setState(() => selectSportsDropDownValue = newValue);
                      if (kDebugMode) {
                        print("option========>>>>>> $selectSportsDropDownValue");
                      }
                      if (kDebugMode) {
                        print("optionList $selectSportsDropDownValue");
                      }
                    },
                  ),
                )),
          ),
          dateController.text.isEmpty
              ? FutureBuilder(
                  future: myFutureList,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      const Center(
                        child: NoDataFound(),
                      );
                    }
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(child: CustomLoader());
                      case ConnectionState.done:
                        if (snapshot.hasData) {
                          List<Records>? records = snapshot.data?.records;
                          if (records != null) {
                            if (status_dropdown_value == "All") {
                              return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.only(top: 5),
                                shrinkWrap: true,
                                itemCount: records.length,
                                itemBuilder: (context, index) {
                                  final item = records[index];
                                  DateTime joiningDate = DateTime.parse(
                                      item.joiningDate.toString());
                                  String displayname = "${item.displayName}";
                                  return Column(
                                    children: [
                                      if(selectSportsDropDownValue == null)
                                        searchcontroller.text.isEmpty
                                      ? Container(
                                    margin: const EdgeInsets.only(
                                        bottom: 10, left: 5, right: 5),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              width: 0.1),
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(15.0),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .start,
                                                  children: [
                                                    CommonText(
                                                        text: displayname
                                                            .toTitleCase() ??
                                                            "",
                                                        fontSize: 15,
                                                        color: AppColors
                                                            .black_txcolor,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold),
                                                    const SizedBox(
                                                        height: 8),
                                                    _CommonRow(
                                                        "REQUEST DATE : ",
                                                        DateFormat(
                                                            'yMMMd')
                                                            .format(
                                                            joiningDate)),
                                                    const SizedBox(
                                                        height: 8),
                                                    if (item.approvalDate !=
                                                        null)
                                                      _CommonRow(
                                                          "APPROVAL DATE : ",
                                                          DateFormat('yMMMd').format(DateTime.parse(item
                                                              .approvalDate
                                                              .toString() ??
                                                              "")) ??
                                                              ""),
                                                    if (item.approvalDate ==
                                                        null)
                                                      _CommonRow(
                                                          "APPROVAL DATE : ",
                                                          ""),
                                                    const SizedBox(
                                                        height: 8),
                                                    _CommonRow(
                                                        "SUBSCRIPTION : ",
                                                        item.subscription ??
                                                            ""),
                                                    const SizedBox(
                                                        height: 8),
                                                    _CommonRow("PRICE : ",
                                                        " ${"\$${item.price}" ?? ""}"),
                                                    const SizedBox(
                                                        height: 8),
                                                    _CommonRow(
                                                        "SOLICITED NAME : ",
                                                        item.solicitedName ??
                                                            ""),
                                                    const SizedBox(
                                                        height: 8),
                                                    _CommonRow("SPORT : ",
                                                        item.sport ?? ""),
                                                    const SizedBox(
                                                        height: 8),
                                                    _CommonRow(
                                                        "TRAINER : ",
                                                        item.trainerName ??
                                                            ""),
                                                    const SizedBox(
                                                        height: 8),
                                                    item.age != null
                                                        ? _CommonRow(
                                                        "AGE : ",
                                                        item.age.toString() ??
                                                            "")
                                                        : _CommonRow(
                                                        "AGE : ", ""),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                            height: 20,
                                                            width: 64.52,
                                                            decoration:
                                                            BoxDecoration(
                                                              color: item.status ==
                                                                  "Pending"
                                                                  ? AppColors
                                                                  .orange
                                                                  : item.status ==
                                                                  "Rejected"
                                                                  ? AppColors.rejected
                                                                  : AppColors.approvedbackground_Color,
                                                              borderRadius:
                                                              BorderRadius.circular(
                                                                  16),
                                                            ),
                                                            child: Center(
                                                              child:
                                                              CommonText(
                                                                text: item
                                                                    .status
                                                                    .toString(),
                                                                fontSize:
                                                                10,
                                                                color: item.status ==
                                                                    "Pending"
                                                                    ? AppColors
                                                                    .onHold
                                                                    : item.status == "Rejected"
                                                                    ? AppColors.onHoldTextColor
                                                                    : AppColors.approvedtext_Color,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w400,
                                                              ),
                                                            )),
                                                        item.status ==
                                                            "Pending"
                                                            ? SizedBox(
                                                          width: 20,
                                                          child: item.subscription ==
                                                              "Free"
                                                              ? PopupMenuButton(
                                                              iconSize: 18,
                                                              itemBuilder: (context) {
                                                                return [
                                                                  PopupMenuItem<int>(
                                                                    value: 0,
                                                                    child: Row(
                                                                      children: [
                                                                        SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                        const SizedBox(width: 10),
                                                                        CommonText(text: AppString.userDetail, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  PopupMenuItem<int>(
                                                                    value: 1,
                                                                    child: Row(
                                                                      children: [
                                                                        SvgPicture.asset(approveIcon, color: AppColors.black_txcolor),
                                                                        const SizedBox(width: 10),
                                                                        Center(
                                                                          child: CommonText(text: AppString.approveRequest, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w500),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  PopupMenuItem<int>(
                                                                    value: 2,
                                                                    child: Container(
                                                                      width: double.infinity,
                                                                      height: 30,
                                                                      color: AppColors.dark_red,
                                                                      child: Center(
                                                                        child: CommonText(text: AppString.cancelSubscription, fontSize: 15, color: AppColors.white, fontWeight: FontWeight.w400),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ];
                                                              },
                                                              onSelected: (value) async {
                                                                if (value == 0) {
                                                                  await manage_profile_userDetail_Api("${item.userID}");
                                                                  _admin_UserDeatil("${item.userID}");
                                                                }
                                                                if (value == 1) {
                                                                  _approveRequest(item.displayName.toString(), item.userID, item.subscription.toString(), item.status.toString());
                                                                  approvalCommentController.clear();
                                                                }
                                                                if (value == 2) {
                                                                  _cancelSubscriptionRequest(item.displayName.toString(), item.userID.toString());
                                                                }
                                                              })
                                                              : PopupMenuButton(
                                                              iconSize: 18,
                                                              itemBuilder: (context) {
                                                                return [
                                                                  PopupMenuItem<int>(
                                                                    value: 0,
                                                                    child: Row(
                                                                      children: [
                                                                        SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                        const SizedBox(width: 10),
                                                                        CommonText(text: AppString.userDetail, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  PopupMenuItem<int>(
                                                                    value: 1,
                                                                    child: Row(
                                                                      children: [
                                                                        SvgPicture.asset(approveIcon, color: AppColors.black_txcolor),
                                                                        const SizedBox(width: 10),
                                                                        Center(
                                                                          child: CommonText(text: AppString.approveRequest, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w500),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  PopupMenuItem<int>(
                                                                    value: 2,
                                                                    child: Container(
                                                                      width: double.infinity,
                                                                      height: 30,
                                                                      color: AppColors.dark_red,
                                                                      child: Center(
                                                                        child: CommonText(text: AppString.cancelSubscription, fontSize: 15, color: AppColors.white, fontWeight: FontWeight.w400),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ];
                                                              },
                                                              onSelected: (value) async {
                                                                if (value == 0) {
                                                                  await manage_profile_userDetail_Api("${item.userID}");
                                                                  _admin_UserDeatil("${item.userID}");
                                                                }
                                                                // if (value == 1) {
                                                                //   _assignTrainer(item.displayName.toString(), item.userID);
                                                                // }
                                                                if (value == 1) {
                                                                  _approveRequest(item.displayName.toString(), item.userID, item.subscription.toString(), item.status.toString());
                                                                  approvalCommentController.clear();
                                                                }
                                                                if (value == 2) {
                                                                  _cancelSubscriptionRequest(item.displayName.toString(), item.userID.toString());
                                                                }
                                                              }),
                                                        )
                                                            : item.subscription ==
                                                            "Platinum" ||
                                                            item.subscription ==
                                                                "Gold"
                                                            ? item.status ==
                                                            "Rejected"
                                                            ? Container(
                                                          width: 20,
                                                          child: PopupMenuButton(
                                                            iconSize: 18,
                                                            itemBuilder: (context) {
                                                              return [
                                                                PopupMenuItem<int>(
                                                                  value: 0,
                                                                  child: Row(
                                                                    children: [
                                                                      SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                      const SizedBox(width: 10),
                                                                      const CommonText(text: "Rejected Reason", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ];
                                                            },
                                                            onSelected: (value) async {
                                                              if (value == 0) {
                                                                print("My account menu is selected.");
                                                                await manage_profile_userDetail_Api("${item.userID}");
                                                                _admin_RejectedReason("${item.userID}", "${item.comment}");
                                                              }
                                                            },
                                                          ),
                                                        )
                                                            : Container(
                                                          width: 20,
                                                          child: PopupMenuButton(
                                                              iconSize: 18,
                                                              itemBuilder: (context) {
                                                                return [
                                                                  PopupMenuItem<int>(
                                                                    value: 0,
                                                                    child: Row(
                                                                      children: [
                                                                        SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                        const SizedBox(width: 10),
                                                                        const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  PopupMenuItem<int>(
                                                                    value: 1,
                                                                    child: Row(
                                                                      children: [
                                                                        SvgPicture.asset(addUserIcon, color: AppColors.black_txcolor),
                                                                        const SizedBox(width: 10),
                                                                        const CommonText(text: "Change Trainer", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  PopupMenuItem<int>(
                                                                    value: 2,
                                                                    child: Row(
                                                                      children: [
                                                                        SvgPicture.asset(addUserIcon, color: AppColors.black_txcolor),
                                                                        const SizedBox(width: 10),
                                                                        const CommonText(text: "Change Player ID#", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ];
                                                              },
                                                              onSelected: (value) async {
                                                                if (value == 0) {
                                                                  print("My account menu is selected.");
                                                                  await manage_profile_userDetail_Api("${item.userID}");
                                                                  _admin_UserDeatil("${item.userID}");
                                                                } else if (value == 1) {
                                                                  print("Settings menu is selected.");
                                                                  _changeTrainer("${item.displayName}", "${item.trainerName}", item.userID, item.trainerID.toString());
                                                                  PreferenceUtils.remove("athleteTrainer");
                                                                } else if (value == 2) {
                                                                  print("Settings menu is selected.");
                                                                  await _changePlayerID("${item.playerId ?? ""}", "${item.userID}");
                                                                }
                                                              }),
                                                        )
                                                            : item.status ==
                                                            "Rejected"
                                                            ? Container(
                                                          width: 20,
                                                          child: PopupMenuButton(
                                                            iconSize: 18,
                                                            itemBuilder: (context) {
                                                              return [
                                                                PopupMenuItem<int>(
                                                                  value: 0,
                                                                  child: Row(
                                                                    children: [
                                                                      SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                      const SizedBox(width: 10),
                                                                      const CommonText(text: "Rejected Reason", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ];
                                                            },
                                                            onSelected: (value) async {
                                                              if (value == 0) {
                                                                print("My account menu is selected.");
                                                                await manage_profile_userDetail_Api("${item.userID}");
                                                                _admin_RejectedReason("${item.userID}", "${item.comment}");
                                                              }
                                                            },
                                                          ),
                                                        )
                                                            : item.subscription == "Free"
                                                            ? Container(
                                                          width: 20,
                                                          child: PopupMenuButton(
                                                            iconSize: 18,
                                                            itemBuilder: (context) {
                                                              return [
                                                                PopupMenuItem<int>(
                                                                  value: 0,
                                                                  child: Row(
                                                                    children: [
                                                                      SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                      const SizedBox(width: 10),
                                                                      const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ];
                                                            },
                                                            onSelected: (value) async {
                                                              if (value == 0) {
                                                                print("My account menu is selected.");
                                                                await manage_profile_userDetail_Api("${item.userID}");
                                                                _admin_UserDeatil("${item.userID}");
                                                              }
                                                            },
                                                          ),
                                                        )
                                                            : Container(
                                                          width: 20,
                                                          child: PopupMenuButton(
                                                            iconSize: 18,
                                                            itemBuilder: (context) {
                                                              return [
                                                                PopupMenuItem<int>(
                                                                  value: 0,
                                                                  child: Row(
                                                                    children: [
                                                                      SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                      const SizedBox(width: 10),
                                                                      const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ];
                                                            },
                                                            onSelected: (value) async {
                                                              if (value == 0) {
                                                                print("My account menu is selected.");
                                                                await manage_profile_userDetail_Api("${item.userID}");
                                                                _admin_UserDeatil("${item.userID}");
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                      : item.displayName!.toLowerCase().contains(searchString) || item.subscription!.toLowerCase().contains(searchString)
                                      ? Container(
                                    margin: const EdgeInsets.only(
                                        bottom: 10,
                                        left: 5,
                                        right: 5),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              width: 0.1),
                                          borderRadius:
                                          BorderRadius.circular(
                                              10)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(
                                            15.0),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .start,
                                                  children: [
                                                    CommonText(
                                                        text: displayname
                                                            .toTitleCase() ??
                                                            "",
                                                        fontSize: 15,
                                                        color: AppColors
                                                            .black_txcolor,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold),
                                                    const SizedBox(
                                                        height: 8),
                                                    _CommonRow(
                                                        "REQUEST DATE : ",
                                                        DateFormat(
                                                            'yMMMd')
                                                            .format(
                                                            joiningDate)),
                                                    const SizedBox(
                                                        height: 8),
                                                    if (item.approvalDate !=
                                                        null)
                                                      _CommonRow(
                                                          "APPROVAL DATE : ",
                                                          DateFormat('yMMMd').format(DateTime.parse(item.approvalDate.toString() ??
                                                              "")) ??
                                                              ""),
                                                    if (item.approvalDate ==
                                                        null)
                                                      _CommonRow(
                                                          "APPROVAL DATE : ",
                                                          ""),
                                                    const SizedBox(
                                                        height: 8),
                                                    _CommonRow(
                                                        "SUBSCRIPTION : ",
                                                        item.subscription ??
                                                            ""),
                                                    const SizedBox(
                                                        height: 8),
                                                    _CommonRow(
                                                        "PRICE : ",
                                                        " ${"\$${item.price}" ?? ""}"),
                                                    const SizedBox(
                                                        height: 8),
                                                    _CommonRow(
                                                        "SOLICITED NAME : ",
                                                        item.solicitedName ??
                                                            ""),
                                                    const SizedBox(
                                                        height: 8),
                                                    _CommonRow(
                                                        "SPORT : ",
                                                        item.sport ??
                                                            ""),
                                                    const SizedBox(
                                                        height: 8),
                                                    _CommonRow(
                                                        "TRAINER : ",
                                                        item.trainerName ??
                                                            ""),
                                                    const SizedBox(
                                                        height: 8),
                                                    item.age != null
                                                        ? _CommonRow(
                                                        "AGE : ",
                                                        item.age.toString() ??
                                                            "")
                                                        : _CommonRow(
                                                        "AGE : ",
                                                        ""),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                            height:
                                                            20,
                                                            width:
                                                            64.52,
                                                            decoration:
                                                            BoxDecoration(
                                                              color: item.status ==
                                                                  "Pending"
                                                                  ? AppColors.orange
                                                                  : item.status == "Rejected"
                                                                  ? AppColors.rejected
                                                                  : AppColors.approvedbackground_Color,
                                                              borderRadius:
                                                              BorderRadius.circular(16),
                                                            ),
                                                            child:
                                                            Center(
                                                              child:
                                                              CommonText(
                                                                text: item
                                                                    .status
                                                                    .toString(),
                                                                fontSize:
                                                                10,
                                                                color: item.status == "Pending"
                                                                    ? AppColors.onHold
                                                                    : item.status == "Rejected"
                                                                    ? AppColors.onHoldTextColor
                                                                    : AppColors.approvedtext_Color,
                                                                fontWeight:
                                                                FontWeight.w400,
                                                              ),
                                                            )),
                                                        item.status ==
                                                            "Pending"
                                                            ? SizedBox(
                                                          width:
                                                          20,
                                                          child: item.subscription == "Free"
                                                              ? PopupMenuButton(
                                                              iconSize: 18,
                                                              itemBuilder: (context) {
                                                                return [
                                                                  PopupMenuItem<int>(
                                                                    value: 0,
                                                                    child: Row(
                                                                      children: [
                                                                        SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                        const SizedBox(width: 10),
                                                                        CommonText(text: AppString.userDetail, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  PopupMenuItem<int>(
                                                                    value: 1,
                                                                    child: Row(
                                                                      children: [
                                                                        SvgPicture.asset(approveIcon, color: AppColors.black_txcolor),
                                                                        const SizedBox(width: 10),
                                                                        Center(
                                                                          child: CommonText(text: AppString.approveRequest, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w500),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  PopupMenuItem<int>(
                                                                    value: 2,
                                                                    child: Container(
                                                                      width: double.infinity,
                                                                      height: 30,
                                                                      color: AppColors.dark_red,
                                                                      child: Center(
                                                                        child: CommonText(text: AppString.cancelSubscription, fontSize: 15, color: AppColors.white, fontWeight: FontWeight.w400),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ];
                                                              },
                                                              onSelected: (value) async {
                                                                if (value == 0) {
                                                                  await manage_profile_userDetail_Api("${item.userID}");
                                                                  _admin_UserDeatil("${item.userID}");
                                                                }
                                                                if (value == 1) {
                                                                  _approveRequest(item.displayName.toString(), item.userID, item.subscription.toString(), item.status.toString());
                                                                  approvalCommentController.clear();
                                                                }
                                                                if (value == 2) {
                                                                  _cancelSubscriptionRequest(item.displayName.toString(), item.userID.toString());
                                                                }
                                                              })
                                                              : PopupMenuButton(
                                                              iconSize: 18,
                                                              itemBuilder: (context) {
                                                                return [
                                                                  PopupMenuItem<int>(
                                                                    value: 0,
                                                                    child: Row(
                                                                      children: [
                                                                        SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                        const SizedBox(width: 10),
                                                                        CommonText(text: AppString.userDetail, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  PopupMenuItem<int>(
                                                                    value: 1,
                                                                    child: Row(
                                                                      children: [
                                                                        SvgPicture.asset(approveIcon, color: AppColors.black_txcolor),
                                                                        const SizedBox(width: 10),
                                                                        Center(
                                                                          child: CommonText(text: AppString.approveRequest, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w500),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  PopupMenuItem<int>(
                                                                    value: 2,
                                                                    child: Container(
                                                                      width: double.infinity,
                                                                      height: 30,
                                                                      color: AppColors.dark_red,
                                                                      child: Center(
                                                                        child: CommonText(text: AppString.cancelSubscription, fontSize: 15, color: AppColors.white, fontWeight: FontWeight.w400),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ];
                                                              },
                                                              onSelected: (value) async {
                                                                if (value == 0) {
                                                                  await manage_profile_userDetail_Api("${item.userID}");
                                                                  _admin_UserDeatil("${item.userID}");
                                                                }
                                                                // if (value == 1) {
                                                                //   _assignTrainer(item.displayName.toString(), item.userID);
                                                                // }
                                                                if (value == 1) {
                                                                  _approveRequest(item.displayName.toString(), item.userID, item.subscription.toString(), item.status.toString());
                                                                  approvalCommentController.clear();
                                                                }
                                                                if (value == 2) {
                                                                  _cancelSubscriptionRequest(item.displayName.toString(), item.userID.toString());
                                                                }
                                                              }),
                                                        )
                                                            : item.subscription == "Platinum" ||
                                                            item.subscription == "Gold"
                                                            ? Container(
                                                          width: 20,
                                                          child: PopupMenuButton(
                                                              iconSize: 18,
                                                              itemBuilder: (context) {
                                                                return [
                                                                  PopupMenuItem<int>(
                                                                    value: 0,
                                                                    child: Row(
                                                                      children: [
                                                                        SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                        const SizedBox(width: 10),
                                                                        const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  PopupMenuItem<int>(
                                                                    value: 1,
                                                                    child: Row(
                                                                      children: [
                                                                        SvgPicture.asset(addUserIcon, color: AppColors.black_txcolor),
                                                                        const SizedBox(width: 10),
                                                                        const CommonText(text: "Change Trainer", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  PopupMenuItem<int>(
                                                                    value: 2,
                                                                    child: Row(
                                                                      children: [
                                                                        SvgPicture.asset(addUserIcon, color: AppColors.black_txcolor),
                                                                        const SizedBox(width: 10),
                                                                        const CommonText(text: "Change Player ID#", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ];
                                                              },
                                                              onSelected: (value) async {
                                                                if (value == 0) {
                                                                  print("My account menu is selected.");
                                                                  await manage_profile_userDetail_Api("${item.userID}");
                                                                  _admin_UserDeatil("${item.userID}");
                                                                } else if (value == 1) {
                                                                  print("Settings menu is selected.");
                                                                  _changeTrainer("${item.displayName}", "${item.trainerName}", item.userID, item.trainerID.toString());
                                                                  PreferenceUtils.remove("athleteTrainer");
                                                                } else if (value == 2) {
                                                                  print("Settings menu is selected.");
                                                                  await _changePlayerID("${item.playerId ?? ""}", "${item.userID}");
                                                                }
                                                              }),
                                                        )
                                                            : item.subscription == "Free"
                                                            ? Container()
                                                            : Container(
                                                          width: 20,
                                                          child: PopupMenuButton(
                                                            iconSize: 18,
                                                            itemBuilder: (context) {
                                                              return [
                                                                PopupMenuItem<int>(
                                                                  value: 0,
                                                                  child: Row(
                                                                    children: [
                                                                      SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                      const SizedBox(width: 10),
                                                                      const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ];
                                                            },
                                                            onSelected: (value) async {
                                                              if (value == 0) {
                                                                print("My account menu is selected.");
                                                                await manage_profile_userDetail_Api("${item.userID}");
                                                                _admin_UserDeatil("${item.userID}");
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                      : Container(),
                                      if(selectSportsDropDownValue == "All Sports")
                                        searchcontroller.text.isEmpty
                                            ? Container(
                                          margin: const EdgeInsets.only(
                                              bottom: 10, left: 5, right: 5),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                    width: 0.1),
                                                borderRadius:
                                                BorderRadius.circular(10)),
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.all(15.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          CommonText(
                                                              text: displayname
                                                                  .toTitleCase() ??
                                                                  "",
                                                              fontSize: 15,
                                                              color: AppColors
                                                                  .black_txcolor,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "REQUEST DATE : ",
                                                              DateFormat(
                                                                  'yMMMd')
                                                                  .format(
                                                                  joiningDate)),
                                                          const SizedBox(
                                                              height: 8),
                                                          if (item.approvalDate !=
                                                              null)
                                                            _CommonRow(
                                                                "APPROVAL DATE : ",
                                                                DateFormat('yMMMd').format(DateTime.parse(item
                                                                    .approvalDate
                                                                    .toString() ??
                                                                    "")) ??
                                                                    ""),
                                                          if (item.approvalDate ==
                                                              null)
                                                            _CommonRow(
                                                                "APPROVAL DATE : ",
                                                                ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "SUBSCRIPTION : ",
                                                              item.subscription ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow("PRICE : ",
                                                              " ${"\$${item.price}" ?? ""}"),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "SOLICITED NAME : ",
                                                              item.solicitedName ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow("SPORT : ",
                                                              item.sport ?? ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "TRAINER : ",
                                                              item.trainerName ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          item.age != null
                                                              ? _CommonRow(
                                                              "AGE : ",
                                                              item.age.toString() ??
                                                                  "")
                                                              : _CommonRow(
                                                              "AGE : ", ""),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                  height: 20,
                                                                  width: 64.52,
                                                                  decoration:
                                                                  BoxDecoration(
                                                                    color: item.status ==
                                                                        "Pending"
                                                                        ? AppColors
                                                                        .orange
                                                                        : item.status ==
                                                                        "Rejected"
                                                                        ? AppColors.rejected
                                                                        : AppColors.approvedbackground_Color,
                                                                    borderRadius:
                                                                    BorderRadius.circular(
                                                                        16),
                                                                  ),
                                                                  child: Center(
                                                                    child:
                                                                    CommonText(
                                                                      text: item
                                                                          .status
                                                                          .toString(),
                                                                      fontSize:
                                                                      10,
                                                                      color: item.status ==
                                                                          "Pending"
                                                                          ? AppColors
                                                                          .onHold
                                                                          : item.status == "Rejected"
                                                                          ? AppColors.onHoldTextColor
                                                                          : AppColors.approvedtext_Color,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                    ),
                                                                  )),
                                                              item.status ==
                                                                  "Pending"
                                                                  ? SizedBox(
                                                                width: 20,
                                                                child: item.subscription ==
                                                                    "Free"
                                                                    ? PopupMenuButton(
                                                                    iconSize: 18,
                                                                    itemBuilder: (context) {
                                                                      return [
                                                                        PopupMenuItem<int>(
                                                                          value: 0,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              CommonText(text: AppString.userDetail, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 1,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(approveIcon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              Center(
                                                                                child: CommonText(text: AppString.approveRequest, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w500),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 2,
                                                                          child: Container(
                                                                            width: double.infinity,
                                                                            height: 30,
                                                                            color: AppColors.dark_red,
                                                                            child: Center(
                                                                              child: CommonText(text: AppString.cancelSubscription, fontSize: 15, color: AppColors.white, fontWeight: FontWeight.w400),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ];
                                                                    },
                                                                    onSelected: (value) async {
                                                                      if (value == 0) {
                                                                        await manage_profile_userDetail_Api("${item.userID}");
                                                                        _admin_UserDeatil("${item.userID}");
                                                                      }
                                                                      if (value == 1) {
                                                                        _approveRequest(item.displayName.toString(), item.userID, item.subscription.toString(), item.status.toString());
                                                                        approvalCommentController.clear();
                                                                      }
                                                                      if (value == 2) {
                                                                        _cancelSubscriptionRequest(item.displayName.toString(), item.userID.toString());
                                                                      }
                                                                    })
                                                                    : PopupMenuButton(
                                                                    iconSize: 18,
                                                                    itemBuilder: (context) {
                                                                      return [
                                                                        PopupMenuItem<int>(
                                                                          value: 0,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              CommonText(text: AppString.userDetail, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 1,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(approveIcon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              Center(
                                                                                child: CommonText(text: AppString.approveRequest, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w500),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 2,
                                                                          child: Container(
                                                                            width: double.infinity,
                                                                            height: 30,
                                                                            color: AppColors.dark_red,
                                                                            child: Center(
                                                                              child: CommonText(text: AppString.cancelSubscription, fontSize: 15, color: AppColors.white, fontWeight: FontWeight.w400),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ];
                                                                    },
                                                                    onSelected: (value) async {
                                                                      if (value == 0) {
                                                                        await manage_profile_userDetail_Api("${item.userID}");
                                                                        _admin_UserDeatil("${item.userID}");
                                                                      }
                                                                      // if (value == 1) {
                                                                      //   _assignTrainer(item.displayName.toString(), item.userID);
                                                                      // }
                                                                      if (value == 1) {
                                                                        _approveRequest(item.displayName.toString(), item.userID, item.subscription.toString(), item.status.toString());
                                                                        approvalCommentController.clear();
                                                                      }
                                                                      if (value == 2) {
                                                                        _cancelSubscriptionRequest(item.displayName.toString(), item.userID.toString());
                                                                      }
                                                                    }),
                                                              )
                                                                  : item.subscription ==
                                                                  "Platinum" ||
                                                                  item.subscription ==
                                                                      "Gold"
                                                                  ? item.status ==
                                                                  "Rejected"
                                                                  ? Container(
                                                                width: 20,
                                                                child: PopupMenuButton(
                                                                  iconSize: 18,
                                                                  itemBuilder: (context) {
                                                                    return [
                                                                      PopupMenuItem<int>(
                                                                        value: 0,
                                                                        child: Row(
                                                                          children: [
                                                                            SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                            const SizedBox(width: 10),
                                                                            const CommonText(text: "Rejected Reason", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ];
                                                                  },
                                                                  onSelected: (value) async {
                                                                    if (value == 0) {
                                                                      print("My account menu is selected.");
                                                                      await manage_profile_userDetail_Api("${item.userID}");
                                                                      _admin_RejectedReason("${item.userID}", "${item.comment}");
                                                                    }
                                                                  },
                                                                ),
                                                              )
                                                                  : Container(
                                                                width: 20,
                                                                child: PopupMenuButton(
                                                                    iconSize: 18,
                                                                    itemBuilder: (context) {
                                                                      return [
                                                                        PopupMenuItem<int>(
                                                                          value: 0,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 1,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(addUserIcon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              const CommonText(text: "Change Trainer", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 2,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(addUserIcon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              const CommonText(text: "Change Player ID#", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ];
                                                                    },
                                                                    onSelected: (value) async {
                                                                      if (value == 0) {
                                                                        print("My account menu is selected.");
                                                                        await manage_profile_userDetail_Api("${item.userID}");
                                                                        _admin_UserDeatil("${item.userID}");
                                                                      } else if (value == 1) {
                                                                        print("Settings menu is selected.");
                                                                        _changeTrainer("${item.displayName}", "${item.trainerName}", item.userID, item.trainerID.toString());
                                                                        PreferenceUtils.remove("athleteTrainer");
                                                                      } else if (value == 2) {
                                                                        print("Settings menu is selected.");
                                                                        await _changePlayerID("${item.playerId ?? ""}", "${item.userID}");
                                                                      }
                                                                    }),
                                                              )
                                                                  : item.status ==
                                                                  "Rejected"
                                                                  ? Container(
                                                                width: 20,
                                                                child: PopupMenuButton(
                                                                  iconSize: 18,
                                                                  itemBuilder: (context) {
                                                                    return [
                                                                      PopupMenuItem<int>(
                                                                        value: 0,
                                                                        child: Row(
                                                                          children: [
                                                                            SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                            const SizedBox(width: 10),
                                                                            const CommonText(text: "Rejected Reason", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ];
                                                                  },
                                                                  onSelected: (value) async {
                                                                    if (value == 0) {
                                                                      print("My account menu is selected.");
                                                                      await manage_profile_userDetail_Api("${item.userID}");
                                                                      _admin_RejectedReason("${item.userID}", "${item.comment}");
                                                                    }
                                                                  },
                                                                ),
                                                              )
                                                                  : item.subscription == "Free"
                                                                  ? Container(
                                                                width: 20,
                                                                child: PopupMenuButton(
                                                                  iconSize: 18,
                                                                  itemBuilder: (context) {
                                                                    return [
                                                                      PopupMenuItem<int>(
                                                                        value: 0,
                                                                        child: Row(
                                                                          children: [
                                                                            SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                            const SizedBox(width: 10),
                                                                            const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ];
                                                                  },
                                                                  onSelected: (value) async {
                                                                    if (value == 0) {
                                                                      print("My account menu is selected.");
                                                                      await manage_profile_userDetail_Api("${item.userID}");
                                                                      _admin_UserDeatil("${item.userID}");
                                                                    }
                                                                  },
                                                                ),
                                                              )
                                                                  : Container(
                                                                width: 20,
                                                                child: PopupMenuButton(
                                                                  iconSize: 18,
                                                                  itemBuilder: (context) {
                                                                    return [
                                                                      PopupMenuItem<int>(
                                                                        value: 0,
                                                                        child: Row(
                                                                          children: [
                                                                            SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                            const SizedBox(width: 10),
                                                                            const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ];
                                                                  },
                                                                  onSelected: (value) async {
                                                                    if (value == 0) {
                                                                      print("My account menu is selected.");
                                                                      await manage_profile_userDetail_Api("${item.userID}");
                                                                      _admin_UserDeatil("${item.userID}");
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                            : item.displayName!.toLowerCase().contains(searchString) || item.subscription!.toLowerCase().contains(searchString)
                                            ? Container(
                                          margin: const EdgeInsets.only(
                                              bottom: 10,
                                              left: 5,
                                              right: 5),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                    width: 0.1),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    10)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  15.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          CommonText(
                                                              text: displayname
                                                                  .toTitleCase() ??
                                                                  "",
                                                              fontSize: 15,
                                                              color: AppColors
                                                                  .black_txcolor,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "REQUEST DATE : ",
                                                              DateFormat(
                                                                  'yMMMd')
                                                                  .format(
                                                                  joiningDate)),
                                                          const SizedBox(
                                                              height: 8),
                                                          if (item.approvalDate !=
                                                              null)
                                                            _CommonRow(
                                                                "APPROVAL DATE : ",
                                                                DateFormat('yMMMd').format(DateTime.parse(item.approvalDate.toString() ??
                                                                    "")) ??
                                                                    ""),
                                                          if (item.approvalDate ==
                                                              null)
                                                            _CommonRow(
                                                                "APPROVAL DATE : ",
                                                                ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "SUBSCRIPTION : ",
                                                              item.subscription ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "PRICE : ",
                                                              " ${"\$${item.price}" ?? ""}"),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "SOLICITED NAME : ",
                                                              item.solicitedName ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "SPORT : ",
                                                              item.sport ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "TRAINER : ",
                                                              item.trainerName ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          item.age != null
                                                              ? _CommonRow(
                                                              "AGE : ",
                                                              item.age.toString() ??
                                                                  "")
                                                              : _CommonRow(
                                                              "AGE : ",
                                                              ""),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                  height:
                                                                  20,
                                                                  width:
                                                                  64.52,
                                                                  decoration:
                                                                  BoxDecoration(
                                                                    color: item.status ==
                                                                        "Pending"
                                                                        ? AppColors.orange
                                                                        : item.status == "Rejected"
                                                                        ? AppColors.rejected
                                                                        : AppColors.approvedbackground_Color,
                                                                    borderRadius:
                                                                    BorderRadius.circular(16),
                                                                  ),
                                                                  child:
                                                                  Center(
                                                                    child:
                                                                    CommonText(
                                                                      text: item
                                                                          .status
                                                                          .toString(),
                                                                      fontSize:
                                                                      10,
                                                                      color: item.status == "Pending"
                                                                          ? AppColors.onHold
                                                                          : item.status == "Rejected"
                                                                          ? AppColors.onHoldTextColor
                                                                          : AppColors.approvedtext_Color,
                                                                      fontWeight:
                                                                      FontWeight.w400,
                                                                    ),
                                                                  )),
                                                              item.status ==
                                                                  "Pending"
                                                                  ? SizedBox(
                                                                width:
                                                                20,
                                                                child: item.subscription == "Free"
                                                                    ? PopupMenuButton(
                                                                    iconSize: 18,
                                                                    itemBuilder: (context) {
                                                                      return [
                                                                        PopupMenuItem<int>(
                                                                          value: 0,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              CommonText(text: AppString.userDetail, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 1,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(approveIcon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              Center(
                                                                                child: CommonText(text: AppString.approveRequest, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w500),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 2,
                                                                          child: Container(
                                                                            width: double.infinity,
                                                                            height: 30,
                                                                            color: AppColors.dark_red,
                                                                            child: Center(
                                                                              child: CommonText(text: AppString.cancelSubscription, fontSize: 15, color: AppColors.white, fontWeight: FontWeight.w400),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ];
                                                                    },
                                                                    onSelected: (value) async {
                                                                      if (value == 0) {
                                                                        await manage_profile_userDetail_Api("${item.userID}");
                                                                        _admin_UserDeatil("${item.userID}");
                                                                      }
                                                                      if (value == 1) {
                                                                        _approveRequest(item.displayName.toString(), item.userID, item.subscription.toString(), item.status.toString());
                                                                        approvalCommentController.clear();
                                                                      }
                                                                      if (value == 2) {
                                                                        _cancelSubscriptionRequest(item.displayName.toString(), item.userID.toString());
                                                                      }
                                                                    })
                                                                    : PopupMenuButton(
                                                                    iconSize: 18,
                                                                    itemBuilder: (context) {
                                                                      return [
                                                                        PopupMenuItem<int>(
                                                                          value: 0,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              CommonText(text: AppString.userDetail, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 1,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(approveIcon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              Center(
                                                                                child: CommonText(text: AppString.approveRequest, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w500),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 2,
                                                                          child: Container(
                                                                            width: double.infinity,
                                                                            height: 30,
                                                                            color: AppColors.dark_red,
                                                                            child: Center(
                                                                              child: CommonText(text: AppString.cancelSubscription, fontSize: 15, color: AppColors.white, fontWeight: FontWeight.w400),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ];
                                                                    },
                                                                    onSelected: (value) async {
                                                                      if (value == 0) {
                                                                        await manage_profile_userDetail_Api("${item.userID}");
                                                                        _admin_UserDeatil("${item.userID}");
                                                                      }
                                                                      // if (value == 1) {
                                                                      //   _assignTrainer(item.displayName.toString(), item.userID);
                                                                      // }
                                                                      if (value == 1) {
                                                                        _approveRequest(item.displayName.toString(), item.userID, item.subscription.toString(), item.status.toString());
                                                                        approvalCommentController.clear();
                                                                      }
                                                                      if (value == 2) {
                                                                        _cancelSubscriptionRequest(item.displayName.toString(), item.userID.toString());
                                                                      }
                                                                    }),
                                                              )
                                                                  : item.subscription == "Platinum" ||
                                                                  item.subscription == "Gold"
                                                                  ? Container(
                                                                width: 20,
                                                                child: PopupMenuButton(
                                                                    iconSize: 18,
                                                                    itemBuilder: (context) {
                                                                      return [
                                                                        PopupMenuItem<int>(
                                                                          value: 0,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 1,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(addUserIcon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              const CommonText(text: "Change Trainer", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 2,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(addUserIcon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              const CommonText(text: "Change Player ID#", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ];
                                                                    },
                                                                    onSelected: (value) async {
                                                                      if (value == 0) {
                                                                        print("My account menu is selected.");
                                                                        await manage_profile_userDetail_Api("${item.userID}");
                                                                        _admin_UserDeatil("${item.userID}");
                                                                      } else if (value == 1) {
                                                                        print("Settings menu is selected.");
                                                                        _changeTrainer("${item.displayName}", "${item.trainerName}", item.userID, item.trainerID.toString());
                                                                        PreferenceUtils.remove("athleteTrainer");
                                                                      } else if (value == 2) {
                                                                        print("Settings menu is selected.");
                                                                        await _changePlayerID("${item.playerId ?? ""}", "${item.userID}");
                                                                      }
                                                                    }),
                                                              )
                                                                  : item.subscription == "Free"
                                                                  ? Container()
                                                                  : Container(
                                                                width: 20,
                                                                child: PopupMenuButton(
                                                                  iconSize: 18,
                                                                  itemBuilder: (context) {
                                                                    return [
                                                                      PopupMenuItem<int>(
                                                                        value: 0,
                                                                        child: Row(
                                                                          children: [
                                                                            SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                            const SizedBox(width: 10),
                                                                            const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ];
                                                                  },
                                                                  onSelected: (value) async {
                                                                    if (value == 0) {
                                                                      print("My account menu is selected.");
                                                                      await manage_profile_userDetail_Api("${item.userID}");
                                                                      _admin_UserDeatil("${item.userID}");
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                            : Container(),
                                      if(records[index].sport == selectSportsDropDownValue)
                                        searchcontroller.text.isEmpty
                                            ? Container(
                                          margin: const EdgeInsets.only(
                                              bottom: 10, left: 5, right: 5),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                    width: 0.1),
                                                borderRadius:
                                                BorderRadius.circular(10)),
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.all(15.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          CommonText(
                                                              text: displayname
                                                                  .toTitleCase() ??
                                                                  "",
                                                              fontSize: 15,
                                                              color: AppColors
                                                                  .black_txcolor,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "REQUEST DATE : ",
                                                              DateFormat(
                                                                  'yMMMd')
                                                                  .format(
                                                                  joiningDate)),
                                                          const SizedBox(
                                                              height: 8),
                                                          if (item.approvalDate !=
                                                              null)
                                                            _CommonRow(
                                                                "APPROVAL DATE : ",
                                                                DateFormat('yMMMd').format(DateTime.parse(item
                                                                    .approvalDate
                                                                    .toString() ??
                                                                    "")) ??
                                                                    ""),
                                                          if (item.approvalDate ==
                                                              null)
                                                            _CommonRow(
                                                                "APPROVAL DATE : ",
                                                                ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "SUBSCRIPTION : ",
                                                              item.subscription ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow("PRICE : ",
                                                              " ${"\$${item.price}" ?? ""}"),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "SOLICITED NAME : ",
                                                              item.solicitedName ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow("SPORT : ",
                                                              item.sport ?? ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "TRAINER : ",
                                                              item.trainerName ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          item.age != null
                                                              ? _CommonRow(
                                                              "AGE : ",
                                                              item.age.toString() ??
                                                                  "")
                                                              : _CommonRow(
                                                              "AGE : ", ""),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                  height: 20,
                                                                  width: 64.52,
                                                                  decoration:
                                                                  BoxDecoration(
                                                                    color: item.status ==
                                                                        "Pending"
                                                                        ? AppColors
                                                                        .orange
                                                                        : item.status ==
                                                                        "Rejected"
                                                                        ? AppColors.rejected
                                                                        : AppColors.approvedbackground_Color,
                                                                    borderRadius:
                                                                    BorderRadius.circular(
                                                                        16),
                                                                  ),
                                                                  child: Center(
                                                                    child:
                                                                    CommonText(
                                                                      text: item
                                                                          .status
                                                                          .toString(),
                                                                      fontSize:
                                                                      10,
                                                                      color: item.status ==
                                                                          "Pending"
                                                                          ? AppColors
                                                                          .onHold
                                                                          : item.status == "Rejected"
                                                                          ? AppColors.onHoldTextColor
                                                                          : AppColors.approvedtext_Color,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                    ),
                                                                  )),
                                                              item.status ==
                                                                  "Pending"
                                                                  ? SizedBox(
                                                                width: 20,
                                                                child: item.subscription ==
                                                                    "Free"
                                                                    ? PopupMenuButton(
                                                                    iconSize: 18,
                                                                    itemBuilder: (context) {
                                                                      return [
                                                                        PopupMenuItem<int>(
                                                                          value: 0,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              CommonText(text: AppString.userDetail, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 1,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(approveIcon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              Center(
                                                                                child: CommonText(text: AppString.approveRequest, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w500),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 2,
                                                                          child: Container(
                                                                            width: double.infinity,
                                                                            height: 30,
                                                                            color: AppColors.dark_red,
                                                                            child: Center(
                                                                              child: CommonText(text: AppString.cancelSubscription, fontSize: 15, color: AppColors.white, fontWeight: FontWeight.w400),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ];
                                                                    },
                                                                    onSelected: (value) async {
                                                                      if (value == 0) {
                                                                        await manage_profile_userDetail_Api("${item.userID}");
                                                                        _admin_UserDeatil("${item.userID}");
                                                                      }
                                                                      if (value == 1) {
                                                                        _approveRequest(item.displayName.toString(), item.userID, item.subscription.toString(), item.status.toString());
                                                                        approvalCommentController.clear();
                                                                      }
                                                                      if (value == 2) {
                                                                        _cancelSubscriptionRequest(item.displayName.toString(), item.userID.toString());
                                                                      }
                                                                    })
                                                                    : PopupMenuButton(
                                                                    iconSize: 18,
                                                                    itemBuilder: (context) {
                                                                      return [
                                                                        PopupMenuItem<int>(
                                                                          value: 0,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              CommonText(text: AppString.userDetail, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 1,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(approveIcon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              Center(
                                                                                child: CommonText(text: AppString.approveRequest, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w500),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 2,
                                                                          child: Container(
                                                                            width: double.infinity,
                                                                            height: 30,
                                                                            color: AppColors.dark_red,
                                                                            child: Center(
                                                                              child: CommonText(text: AppString.cancelSubscription, fontSize: 15, color: AppColors.white, fontWeight: FontWeight.w400),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ];
                                                                    },
                                                                    onSelected: (value) async {
                                                                      if (value == 0) {
                                                                        await manage_profile_userDetail_Api("${item.userID}");
                                                                        _admin_UserDeatil("${item.userID}");
                                                                      }
                                                                      // if (value == 1) {
                                                                      //   _assignTrainer(item.displayName.toString(), item.userID);
                                                                      // }
                                                                      if (value == 1) {
                                                                        _approveRequest(item.displayName.toString(), item.userID, item.subscription.toString(), item.status.toString());
                                                                        approvalCommentController.clear();
                                                                      }
                                                                      if (value == 2) {
                                                                        _cancelSubscriptionRequest(item.displayName.toString(), item.userID.toString());
                                                                      }
                                                                    }),
                                                              )
                                                                  : item.subscription ==
                                                                  "Platinum" ||
                                                                  item.subscription ==
                                                                      "Gold"
                                                                  ? item.status ==
                                                                  "Rejected"
                                                                  ? Container(
                                                                width: 20,
                                                                child: PopupMenuButton(
                                                                  iconSize: 18,
                                                                  itemBuilder: (context) {
                                                                    return [
                                                                      PopupMenuItem<int>(
                                                                        value: 0,
                                                                        child: Row(
                                                                          children: [
                                                                            SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                            const SizedBox(width: 10),
                                                                            const CommonText(text: "Rejected Reason", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ];
                                                                  },
                                                                  onSelected: (value) async {
                                                                    if (value == 0) {
                                                                      print("My account menu is selected.");
                                                                      await manage_profile_userDetail_Api("${item.userID}");
                                                                      _admin_RejectedReason("${item.userID}", "${item.comment}");
                                                                    }
                                                                  },
                                                                ),
                                                              )
                                                                  : Container(
                                                                width: 20,
                                                                child: PopupMenuButton(
                                                                    iconSize: 18,
                                                                    itemBuilder: (context) {
                                                                      return [
                                                                        PopupMenuItem<int>(
                                                                          value: 0,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 1,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(addUserIcon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              const CommonText(text: "Change Trainer", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 2,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(addUserIcon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              const CommonText(text: "Change Player ID#", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ];
                                                                    },
                                                                    onSelected: (value) async {
                                                                      if (value == 0) {
                                                                        print("My account menu is selected.");
                                                                        await manage_profile_userDetail_Api("${item.userID}");
                                                                        _admin_UserDeatil("${item.userID}");
                                                                      } else if (value == 1) {
                                                                        print("Settings menu is selected.");
                                                                        _changeTrainer("${item.displayName}", "${item.trainerName}", item.userID, item.trainerID.toString());
                                                                        PreferenceUtils.remove("athleteTrainer");
                                                                      } else if (value == 2) {
                                                                        print("Settings menu is selected.");
                                                                        await _changePlayerID("${item.playerId ?? ""}", "${item.userID}");
                                                                      }
                                                                    }),
                                                              )
                                                                  : item.status ==
                                                                  "Rejected"
                                                                  ? Container(
                                                                width: 20,
                                                                child: PopupMenuButton(
                                                                  iconSize: 18,
                                                                  itemBuilder: (context) {
                                                                    return [
                                                                      PopupMenuItem<int>(
                                                                        value: 0,
                                                                        child: Row(
                                                                          children: [
                                                                            SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                            const SizedBox(width: 10),
                                                                            const CommonText(text: "Rejected Reason", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ];
                                                                  },
                                                                  onSelected: (value) async {
                                                                    if (value == 0) {
                                                                      print("My account menu is selected.");
                                                                      await manage_profile_userDetail_Api("${item.userID}");
                                                                      _admin_RejectedReason("${item.userID}", "${item.comment}");
                                                                    }
                                                                  },
                                                                ),
                                                              )
                                                                  : item.subscription == "Free"
                                                                  ? Container(
                                                                width: 20,
                                                                child: PopupMenuButton(
                                                                  iconSize: 18,
                                                                  itemBuilder: (context) {
                                                                    return [
                                                                      PopupMenuItem<int>(
                                                                        value: 0,
                                                                        child: Row(
                                                                          children: [
                                                                            SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                            const SizedBox(width: 10),
                                                                            const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ];
                                                                  },
                                                                  onSelected: (value) async {
                                                                    if (value == 0) {
                                                                      print("My account menu is selected.");
                                                                      await manage_profile_userDetail_Api("${item.userID}");
                                                                      _admin_UserDeatil("${item.userID}");
                                                                    }
                                                                  },
                                                                ),
                                                              )
                                                                  : Container(
                                                                width: 20,
                                                                child: PopupMenuButton(
                                                                  iconSize: 18,
                                                                  itemBuilder: (context) {
                                                                    return [
                                                                      PopupMenuItem<int>(
                                                                        value: 0,
                                                                        child: Row(
                                                                          children: [
                                                                            SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                            const SizedBox(width: 10),
                                                                            const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ];
                                                                  },
                                                                  onSelected: (value) async {
                                                                    if (value == 0) {
                                                                      print("My account menu is selected.");
                                                                      await manage_profile_userDetail_Api("${item.userID}");
                                                                      _admin_UserDeatil("${item.userID}");
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                            : item.displayName!.toLowerCase().contains(searchString) || item.subscription!.toLowerCase().contains(searchString)
                                            ? Container(
                                          margin: const EdgeInsets.only(
                                              bottom: 10,
                                              left: 5,
                                              right: 5),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                    width: 0.1),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    10)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  15.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          CommonText(
                                                              text: displayname
                                                                  .toTitleCase() ??
                                                                  "",
                                                              fontSize: 15,
                                                              color: AppColors
                                                                  .black_txcolor,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "REQUEST DATE : ",
                                                              DateFormat(
                                                                  'yMMMd')
                                                                  .format(
                                                                  joiningDate)),
                                                          const SizedBox(
                                                              height: 8),
                                                          if (item.approvalDate !=
                                                              null)
                                                            _CommonRow(
                                                                "APPROVAL DATE : ",
                                                                DateFormat('yMMMd').format(DateTime.parse(item.approvalDate.toString() ??
                                                                    "")) ??
                                                                    ""),
                                                          if (item.approvalDate ==
                                                              null)
                                                            _CommonRow(
                                                                "APPROVAL DATE : ",
                                                                ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "SUBSCRIPTION : ",
                                                              item.subscription ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "PRICE : ",
                                                              " ${"\$${item.price}" ?? ""}"),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "SOLICITED NAME : ",
                                                              item.solicitedName ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "SPORT : ",
                                                              item.sport ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "TRAINER : ",
                                                              item.trainerName ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          item.age != null
                                                              ? _CommonRow(
                                                              "AGE : ",
                                                              item.age.toString() ??
                                                                  "")
                                                              : _CommonRow(
                                                              "AGE : ",
                                                              ""),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                  height:
                                                                  20,
                                                                  width:
                                                                  64.52,
                                                                  decoration:
                                                                  BoxDecoration(
                                                                    color: item.status ==
                                                                        "Pending"
                                                                        ? AppColors.orange
                                                                        : item.status == "Rejected"
                                                                        ? AppColors.rejected
                                                                        : AppColors.approvedbackground_Color,
                                                                    borderRadius:
                                                                    BorderRadius.circular(16),
                                                                  ),
                                                                  child:
                                                                  Center(
                                                                    child:
                                                                    CommonText(
                                                                      text: item
                                                                          .status
                                                                          .toString(),
                                                                      fontSize:
                                                                      10,
                                                                      color: item.status == "Pending"
                                                                          ? AppColors.onHold
                                                                          : item.status == "Rejected"
                                                                          ? AppColors.onHoldTextColor
                                                                          : AppColors.approvedtext_Color,
                                                                      fontWeight:
                                                                      FontWeight.w400,
                                                                    ),
                                                                  )),
                                                              item.status ==
                                                                  "Pending"
                                                                  ? SizedBox(
                                                                width:
                                                                20,
                                                                child: item.subscription == "Free"
                                                                    ? PopupMenuButton(
                                                                    iconSize: 18,
                                                                    itemBuilder: (context) {
                                                                      return [
                                                                        PopupMenuItem<int>(
                                                                          value: 0,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              CommonText(text: AppString.userDetail, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 1,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(approveIcon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              Center(
                                                                                child: CommonText(text: AppString.approveRequest, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w500),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 2,
                                                                          child: Container(
                                                                            width: double.infinity,
                                                                            height: 30,
                                                                            color: AppColors.dark_red,
                                                                            child: Center(
                                                                              child: CommonText(text: AppString.cancelSubscription, fontSize: 15, color: AppColors.white, fontWeight: FontWeight.w400),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ];
                                                                    },
                                                                    onSelected: (value) async {
                                                                      if (value == 0) {
                                                                        await manage_profile_userDetail_Api("${item.userID}");
                                                                        _admin_UserDeatil("${item.userID}");
                                                                      }
                                                                      if (value == 1) {
                                                                        _approveRequest(item.displayName.toString(), item.userID, item.subscription.toString(), item.status.toString());
                                                                        approvalCommentController.clear();
                                                                      }
                                                                      if (value == 2) {
                                                                        _cancelSubscriptionRequest(item.displayName.toString(), item.userID.toString());
                                                                      }
                                                                    })
                                                                    : PopupMenuButton(
                                                                    iconSize: 18,
                                                                    itemBuilder: (context) {
                                                                      return [
                                                                        PopupMenuItem<int>(
                                                                          value: 0,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              CommonText(text: AppString.userDetail, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 1,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(approveIcon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              Center(
                                                                                child: CommonText(text: AppString.approveRequest, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w500),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 2,
                                                                          child: Container(
                                                                            width: double.infinity,
                                                                            height: 30,
                                                                            color: AppColors.dark_red,
                                                                            child: Center(
                                                                              child: CommonText(text: AppString.cancelSubscription, fontSize: 15, color: AppColors.white, fontWeight: FontWeight.w400),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ];
                                                                    },
                                                                    onSelected: (value) async {
                                                                      if (value == 0) {
                                                                        await manage_profile_userDetail_Api("${item.userID}");
                                                                        _admin_UserDeatil("${item.userID}");
                                                                      }
                                                                      // if (value == 1) {
                                                                      //   _assignTrainer(item.displayName.toString(), item.userID);
                                                                      // }
                                                                      if (value == 1) {
                                                                        _approveRequest(item.displayName.toString(), item.userID, item.subscription.toString(), item.status.toString());
                                                                        approvalCommentController.clear();
                                                                      }
                                                                      if (value == 2) {
                                                                        _cancelSubscriptionRequest(item.displayName.toString(), item.userID.toString());
                                                                      }
                                                                    }),
                                                              )
                                                                  : item.subscription == "Platinum" ||
                                                                  item.subscription == "Gold"
                                                                  ? Container(
                                                                width: 20,
                                                                child: PopupMenuButton(
                                                                    iconSize: 18,
                                                                    itemBuilder: (context) {
                                                                      return [
                                                                        PopupMenuItem<int>(
                                                                          value: 0,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 1,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(addUserIcon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              const CommonText(text: "Change Trainer", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 2,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(addUserIcon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              const CommonText(text: "Change Player ID#", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ];
                                                                    },
                                                                    onSelected: (value) async {
                                                                      if (value == 0) {
                                                                        print("My account menu is selected.");
                                                                        await manage_profile_userDetail_Api("${item.userID}");
                                                                        _admin_UserDeatil("${item.userID}");
                                                                      } else if (value == 1) {
                                                                        print("Settings menu is selected.");
                                                                        _changeTrainer("${item.displayName}", "${item.trainerName}", item.userID, item.trainerID.toString());
                                                                        PreferenceUtils.remove("athleteTrainer");
                                                                      } else if (value == 2) {
                                                                        print("Settings menu is selected.");
                                                                        await _changePlayerID("${item.playerId ?? ""}", "${item.userID}");
                                                                      }
                                                                    }),
                                                              )
                                                                  : item.subscription == "Free"
                                                                  ? Container()
                                                                  : Container(
                                                                width: 20,
                                                                child: PopupMenuButton(
                                                                  iconSize: 18,
                                                                  itemBuilder: (context) {
                                                                    return [
                                                                      PopupMenuItem<int>(
                                                                        value: 0,
                                                                        child: Row(
                                                                          children: [
                                                                            SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                            const SizedBox(width: 10),
                                                                            const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ];
                                                                  },
                                                                  onSelected: (value) async {
                                                                    if (value == 0) {
                                                                      print("My account menu is selected.");
                                                                      await manage_profile_userDetail_Api("${item.userID}");
                                                                      _admin_UserDeatil("${item.userID}");
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                            : Container(),                                    ],
                                  );

                                },
                              );
                            } else if (status_dropdown_value == "Approved") {
                              return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.only(top: 5),
                                shrinkWrap: true,
                                itemCount: records.length,
                                itemBuilder: (context, index) {
                                  final item = records[index];
                                  DateTime joiningDate = DateTime.parse(
                                      item.joiningDate.toString());
                                  String displayname = "${item.displayName}";
                                  return item.displayName!.toLowerCase().contains(searchString) || item.subscription!.toLowerCase().contains(searchString)
                                      ? item.status == "Approved"
                                          ? Column(
                                    children: [
                                      if(selectSportsDropDownValue == null)
                                        Container(
                                          margin: const EdgeInsets.only(
                                              bottom: 10,
                                              left: 5,
                                              right: 5),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                    width: 0.1),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    10)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  15.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          CommonText(
                                                              text: displayname
                                                                  .toTitleCase() ??
                                                                  "",
                                                              fontSize: 15,
                                                              color: AppColors
                                                                  .black_txcolor,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "REQUEST DATE : ",
                                                              DateFormat(
                                                                  'yMMMd')
                                                                  .format(
                                                                  joiningDate)),
                                                          const SizedBox(
                                                              height: 8),
                                                          if (item.approvalDate !=
                                                              null)
                                                            _CommonRow(
                                                                "APPROVAL DATE : ",
                                                                DateFormat('yMMMd').format(DateTime.parse(item.approvalDate.toString() ??
                                                                    "")) ??
                                                                    ""),
                                                          if (item.approvalDate ==
                                                              null)
                                                            _CommonRow(
                                                                "APPROVAL DATE : ",
                                                                ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "SUBSCRIPTION : ",
                                                              item.subscription ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "PRICE : ",
                                                              " ${"\$${item.price}" ?? ""}"),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "SOLICITED NAME : ",
                                                              item.solicitedName ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "SPORT : ",
                                                              item.sport ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "TRAINER : ",
                                                              item.trainerName ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          item.age != null
                                                              ? _CommonRow(
                                                              "AGE : ",
                                                              item.age.toString() ??
                                                                  "")
                                                              : _CommonRow(
                                                              "AGE : ",
                                                              ""),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                  height:
                                                                  20,
                                                                  width:
                                                                  64.52,
                                                                  decoration:
                                                                  BoxDecoration(
                                                                    color: item.status ==
                                                                        "Pending"
                                                                        ? AppColors.orange
                                                                        : item.status == "Rejected"
                                                                        ? AppColors.rejected
                                                                        : AppColors.approvedbackground_Color,
                                                                    borderRadius:
                                                                    BorderRadius.circular(16),
                                                                  ),
                                                                  child:
                                                                  Center(
                                                                    child:
                                                                    CommonText(
                                                                      text: item
                                                                          .status
                                                                          .toString(),
                                                                      fontSize:
                                                                      10,
                                                                      color: item.status == "Pending"
                                                                          ? AppColors.onHold
                                                                          : item.status == "Rejected"
                                                                          ? AppColors.onHoldTextColor
                                                                          : AppColors.approvedtext_Color,
                                                                      fontWeight:
                                                                      FontWeight.w400,
                                                                    ),
                                                                  )),
                                                              item.status ==
                                                                  "Pending"
                                                                  ? SizedBox(
                                                                width:
                                                                20,
                                                                child: item.subscription == "Free"
                                                                    ? PopupMenuButton(
                                                                    iconSize: 18,
                                                                    itemBuilder: (context) {
                                                                      return [
                                                                        PopupMenuItem<int>(
                                                                          value: 0,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              CommonText(text: AppString.userDetail, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 1,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(approveIcon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              Center(
                                                                                child: CommonText(text: AppString.approveRequest, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w500),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 2,
                                                                          child: Container(
                                                                            width: double.infinity,
                                                                            height: 30,
                                                                            color: AppColors.dark_red,
                                                                            child: Center(
                                                                              child: CommonText(text: AppString.cancelSubscription, fontSize: 15, color: AppColors.white, fontWeight: FontWeight.w400),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ];
                                                                    },
                                                                    onSelected: (value) async {
                                                                      if (value == 0) {
                                                                        await manage_profile_userDetail_Api("${item.userID}");
                                                                        _admin_UserDeatil("${item.userID}");
                                                                      }
                                                                      if (value == 1) {
                                                                        _approveRequest(item.displayName.toString(), item.userID, item.subscription.toString(), item.status.toString());
                                                                        approvalCommentController.clear();
                                                                      }
                                                                      if (value == 2) {
                                                                        _cancelSubscriptionRequest(item.displayName.toString(), item.userID.toString());
                                                                      }
                                                                    })
                                                                    : PopupMenuButton(
                                                                    iconSize: 18,
                                                                    itemBuilder: (context) {
                                                                      return [
                                                                        PopupMenuItem<int>(
                                                                          value: 0,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              CommonText(text: AppString.userDetail, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 1,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(approveIcon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              Center(
                                                                                child: CommonText(text: AppString.approveRequest, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w500),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 2,
                                                                          child: Container(
                                                                            width: double.infinity,
                                                                            height: 30,
                                                                            color: AppColors.dark_red,
                                                                            child: Center(
                                                                              child: CommonText(text: AppString.cancelSubscription, fontSize: 15, color: AppColors.white, fontWeight: FontWeight.w400),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ];
                                                                    },
                                                                    onSelected: (value) async {
                                                                      if (value == 0) {
                                                                        await manage_profile_userDetail_Api("${item.userID}");
                                                                        _admin_UserDeatil("${item.userID}");
                                                                      }
                                                                      // if (value == 1) {
                                                                      //   _assignTrainer(item.displayName.toString(), item.userID);
                                                                      // }
                                                                      if (value == 1) {
                                                                        _approveRequest(item.displayName.toString(), item.userID, item.subscription.toString(), item.status.toString());
                                                                        approvalCommentController.clear();
                                                                      }
                                                                      if (value == 2) {
                                                                        _cancelSubscriptionRequest(item.displayName.toString(), item.userID.toString());
                                                                      }
                                                                    }),
                                                              )
                                                                  : item.subscription == "Platinum" ||
                                                                  item.subscription == "Gold"
                                                                  ? Container(
                                                                width: 20,
                                                                child: PopupMenuButton(
                                                                    iconSize: 18,
                                                                    itemBuilder: (context) {
                                                                      return [
                                                                        PopupMenuItem<int>(
                                                                          value: 0,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 1,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(addUserIcon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              const CommonText(text: "Change Trainer", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 2,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(addUserIcon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              const CommonText(text: "Change Player ID#", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ];
                                                                    },
                                                                    onSelected: (value) async {
                                                                      if (value == 0) {
                                                                        print("My account menu is selected.");
                                                                        await manage_profile_userDetail_Api("${item.userID}");
                                                                        _admin_UserDeatil("${item.userID}");
                                                                      } else if (value == 1) {
                                                                        print("Settings menu is selected.");
                                                                        _changeTrainer("${item.displayName}", "${item.trainerName}", item.userID, item.trainerID.toString());
                                                                        PreferenceUtils.remove("athleteTrainer");
                                                                      } else if (value == 2) {
                                                                        print("Settings menu is selected.");
                                                                        await _changePlayerID("${item.playerId ?? ""}", "${item.userID}");
                                                                      }
                                                                    }),
                                                              )
                                                                  : item.subscription == "Free"
                                                                  ? Container(
                                                                width: 20,
                                                                child: PopupMenuButton(
                                                                  iconSize: 18,
                                                                  itemBuilder: (context) {
                                                                    return [
                                                                      PopupMenuItem<int>(
                                                                        value: 0,
                                                                        child: Row(
                                                                          children: [
                                                                            SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                            const SizedBox(width: 10),
                                                                            const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ];
                                                                  },
                                                                  onSelected: (value) async {
                                                                    if (value == 0) {
                                                                      print("My account menu is selected.");
                                                                      await manage_profile_userDetail_Api("${item.userID}");
                                                                      _admin_UserDeatil("${item.userID}");
                                                                    }
                                                                  },
                                                                ),
                                                              )
                                                                  : Container(
                                                                width: 20,
                                                                child: PopupMenuButton(
                                                                  iconSize: 18,
                                                                  itemBuilder: (context) {
                                                                    return [
                                                                      PopupMenuItem<int>(
                                                                        value: 0,
                                                                        child: Row(
                                                                          children: [
                                                                            SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                            const SizedBox(width: 10),
                                                                            const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ];
                                                                  },
                                                                  onSelected: (value) async {
                                                                    if (value == 0) {
                                                                      print("My account menu is selected.");
                                                                      await manage_profile_userDetail_Api("${item.userID}");
                                                                      _admin_UserDeatil("${item.userID}");
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      if(selectSportsDropDownValue == "All Sports")
                                        Container(
                                          margin: const EdgeInsets.only(
                                              bottom: 10,
                                              left: 5,
                                              right: 5),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                    width: 0.1),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    10)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  15.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          CommonText(
                                                              text: displayname
                                                                  .toTitleCase() ??
                                                                  "",
                                                              fontSize: 15,
                                                              color: AppColors
                                                                  .black_txcolor,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "REQUEST DATE : ",
                                                              DateFormat(
                                                                  'yMMMd')
                                                                  .format(
                                                                  joiningDate)),
                                                          const SizedBox(
                                                              height: 8),
                                                          if (item.approvalDate !=
                                                              null)
                                                            _CommonRow(
                                                                "APPROVAL DATE : ",
                                                                DateFormat('yMMMd').format(DateTime.parse(item.approvalDate.toString() ??
                                                                    "")) ??
                                                                    ""),
                                                          if (item.approvalDate ==
                                                              null)
                                                            _CommonRow(
                                                                "APPROVAL DATE : ",
                                                                ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "SUBSCRIPTION : ",
                                                              item.subscription ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "PRICE : ",
                                                              " ${"\$${item.price}" ?? ""}"),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "SOLICITED NAME : ",
                                                              item.solicitedName ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "SPORT : ",
                                                              item.sport ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "TRAINER : ",
                                                              item.trainerName ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          item.age != null
                                                              ? _CommonRow(
                                                              "AGE : ",
                                                              item.age.toString() ??
                                                                  "")
                                                              : _CommonRow(
                                                              "AGE : ",
                                                              ""),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                  height:
                                                                  20,
                                                                  width:
                                                                  64.52,
                                                                  decoration:
                                                                  BoxDecoration(
                                                                    color: item.status ==
                                                                        "Pending"
                                                                        ? AppColors.orange
                                                                        : item.status == "Rejected"
                                                                        ? AppColors.rejected
                                                                        : AppColors.approvedbackground_Color,
                                                                    borderRadius:
                                                                    BorderRadius.circular(16),
                                                                  ),
                                                                  child:
                                                                  Center(
                                                                    child:
                                                                    CommonText(
                                                                      text: item
                                                                          .status
                                                                          .toString(),
                                                                      fontSize:
                                                                      10,
                                                                      color: item.status == "Pending"
                                                                          ? AppColors.onHold
                                                                          : item.status == "Rejected"
                                                                          ? AppColors.onHoldTextColor
                                                                          : AppColors.approvedtext_Color,
                                                                      fontWeight:
                                                                      FontWeight.w400,
                                                                    ),
                                                                  )),
                                                              item.status ==
                                                                  "Pending"
                                                                  ? SizedBox(
                                                                width:
                                                                20,
                                                                child: item.subscription == "Free"
                                                                    ? PopupMenuButton(
                                                                    iconSize: 18,
                                                                    itemBuilder: (context) {
                                                                      return [
                                                                        PopupMenuItem<int>(
                                                                          value: 0,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              CommonText(text: AppString.userDetail, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 1,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(approveIcon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              Center(
                                                                                child: CommonText(text: AppString.approveRequest, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w500),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 2,
                                                                          child: Container(
                                                                            width: double.infinity,
                                                                            height: 30,
                                                                            color: AppColors.dark_red,
                                                                            child: Center(
                                                                              child: CommonText(text: AppString.cancelSubscription, fontSize: 15, color: AppColors.white, fontWeight: FontWeight.w400),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ];
                                                                    },
                                                                    onSelected: (value) async {
                                                                      if (value == 0) {
                                                                        await manage_profile_userDetail_Api("${item.userID}");
                                                                        _admin_UserDeatil("${item.userID}");
                                                                      }
                                                                      if (value == 1) {
                                                                        _approveRequest(item.displayName.toString(), item.userID, item.subscription.toString(), item.status.toString());
                                                                        approvalCommentController.clear();
                                                                      }
                                                                      if (value == 2) {
                                                                        _cancelSubscriptionRequest(item.displayName.toString(), item.userID.toString());
                                                                      }
                                                                    })
                                                                    : PopupMenuButton(
                                                                    iconSize: 18,
                                                                    itemBuilder: (context) {
                                                                      return [
                                                                        PopupMenuItem<int>(
                                                                          value: 0,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              CommonText(text: AppString.userDetail, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 1,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(approveIcon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              Center(
                                                                                child: CommonText(text: AppString.approveRequest, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w500),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 2,
                                                                          child: Container(
                                                                            width: double.infinity,
                                                                            height: 30,
                                                                            color: AppColors.dark_red,
                                                                            child: Center(
                                                                              child: CommonText(text: AppString.cancelSubscription, fontSize: 15, color: AppColors.white, fontWeight: FontWeight.w400),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ];
                                                                    },
                                                                    onSelected: (value) async {
                                                                      if (value == 0) {
                                                                        await manage_profile_userDetail_Api("${item.userID}");
                                                                        _admin_UserDeatil("${item.userID}");
                                                                      }
                                                                      // if (value == 1) {
                                                                      //   _assignTrainer(item.displayName.toString(), item.userID);
                                                                      // }
                                                                      if (value == 1) {
                                                                        _approveRequest(item.displayName.toString(), item.userID, item.subscription.toString(), item.status.toString());
                                                                        approvalCommentController.clear();
                                                                      }
                                                                      if (value == 2) {
                                                                        _cancelSubscriptionRequest(item.displayName.toString(), item.userID.toString());
                                                                      }
                                                                    }),
                                                              )
                                                                  : item.subscription == "Platinum" ||
                                                                  item.subscription == "Gold"
                                                                  ? Container(
                                                                width: 20,
                                                                child: PopupMenuButton(
                                                                    iconSize: 18,
                                                                    itemBuilder: (context) {
                                                                      return [
                                                                        PopupMenuItem<int>(
                                                                          value: 0,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 1,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(addUserIcon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              const CommonText(text: "Change Trainer", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 2,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(addUserIcon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              const CommonText(text: "Change Player ID#", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ];
                                                                    },
                                                                    onSelected: (value) async {
                                                                      if (value == 0) {
                                                                        print("My account menu is selected.");
                                                                        await manage_profile_userDetail_Api("${item.userID}");
                                                                        _admin_UserDeatil("${item.userID}");
                                                                      } else if (value == 1) {
                                                                        print("Settings menu is selected.");
                                                                        _changeTrainer("${item.displayName}", "${item.trainerName}", item.userID, item.trainerID.toString());
                                                                        PreferenceUtils.remove("athleteTrainer");
                                                                      } else if (value == 2) {
                                                                        print("Settings menu is selected.");
                                                                        await _changePlayerID("${item.playerId ?? ""}", "${item.userID}");
                                                                      }
                                                                    }),
                                                              )
                                                                  : item.subscription == "Free"
                                                                  ? Container(
                                                                width: 20,
                                                                child: PopupMenuButton(
                                                                  iconSize: 18,
                                                                  itemBuilder: (context) {
                                                                    return [
                                                                      PopupMenuItem<int>(
                                                                        value: 0,
                                                                        child: Row(
                                                                          children: [
                                                                            SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                            const SizedBox(width: 10),
                                                                            const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ];
                                                                  },
                                                                  onSelected: (value) async {
                                                                    if (value == 0) {
                                                                      print("My account menu is selected.");
                                                                      await manage_profile_userDetail_Api("${item.userID}");
                                                                      _admin_UserDeatil("${item.userID}");
                                                                    }
                                                                  },
                                                                ),
                                                              )
                                                                  : Container(
                                                                width: 20,
                                                                child: PopupMenuButton(
                                                                  iconSize: 18,
                                                                  itemBuilder: (context) {
                                                                    return [
                                                                      PopupMenuItem<int>(
                                                                        value: 0,
                                                                        child: Row(
                                                                          children: [
                                                                            SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                            const SizedBox(width: 10),
                                                                            const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ];
                                                                  },
                                                                  onSelected: (value) async {
                                                                    if (value == 0) {
                                                                      print("My account menu is selected.");
                                                                      await manage_profile_userDetail_Api("${item.userID}");
                                                                      _admin_UserDeatil("${item.userID}");
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      if(records[index].sport == selectSportsDropDownValue)
                                        Container(
                                          margin: const EdgeInsets.only(
                                              bottom: 10,
                                              left: 5,
                                              right: 5),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                    width: 0.1),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    10)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  15.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          CommonText(
                                                              text: displayname
                                                                  .toTitleCase() ??
                                                                  "",
                                                              fontSize: 15,
                                                              color: AppColors
                                                                  .black_txcolor,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "REQUEST DATE : ",
                                                              DateFormat(
                                                                  'yMMMd')
                                                                  .format(
                                                                  joiningDate)),
                                                          const SizedBox(
                                                              height: 8),
                                                          if (item.approvalDate !=
                                                              null)
                                                            _CommonRow(
                                                                "APPROVAL DATE : ",
                                                                DateFormat('yMMMd').format(DateTime.parse(item.approvalDate.toString() ??
                                                                    "")) ??
                                                                    ""),
                                                          if (item.approvalDate ==
                                                              null)
                                                            _CommonRow(
                                                                "APPROVAL DATE : ",
                                                                ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "SUBSCRIPTION : ",
                                                              item.subscription ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "PRICE : ",
                                                              " ${"\$${item.price}" ?? ""}"),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "SOLICITED NAME : ",
                                                              item.solicitedName ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "SPORT : ",
                                                              item.sport ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "TRAINER : ",
                                                              item.trainerName ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          item.age != null
                                                              ? _CommonRow(
                                                              "AGE : ",
                                                              item.age.toString() ??
                                                                  "")
                                                              : _CommonRow(
                                                              "AGE : ",
                                                              ""),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                  height:
                                                                  20,
                                                                  width:
                                                                  64.52,
                                                                  decoration:
                                                                  BoxDecoration(
                                                                    color: item.status ==
                                                                        "Pending"
                                                                        ? AppColors.orange
                                                                        : item.status == "Rejected"
                                                                        ? AppColors.rejected
                                                                        : AppColors.approvedbackground_Color,
                                                                    borderRadius:
                                                                    BorderRadius.circular(16),
                                                                  ),
                                                                  child:
                                                                  Center(
                                                                    child:
                                                                    CommonText(
                                                                      text: item
                                                                          .status
                                                                          .toString(),
                                                                      fontSize:
                                                                      10,
                                                                      color: item.status == "Pending"
                                                                          ? AppColors.onHold
                                                                          : item.status == "Rejected"
                                                                          ? AppColors.onHoldTextColor
                                                                          : AppColors.approvedtext_Color,
                                                                      fontWeight:
                                                                      FontWeight.w400,
                                                                    ),
                                                                  )),
                                                              item.status ==
                                                                  "Pending"
                                                                  ? SizedBox(
                                                                width:
                                                                20,
                                                                child: item.subscription == "Free"
                                                                    ? PopupMenuButton(
                                                                    iconSize: 18,
                                                                    itemBuilder: (context) {
                                                                      return [
                                                                        PopupMenuItem<int>(
                                                                          value: 0,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              CommonText(text: AppString.userDetail, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 1,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(approveIcon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              Center(
                                                                                child: CommonText(text: AppString.approveRequest, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w500),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 2,
                                                                          child: Container(
                                                                            width: double.infinity,
                                                                            height: 30,
                                                                            color: AppColors.dark_red,
                                                                            child: Center(
                                                                              child: CommonText(text: AppString.cancelSubscription, fontSize: 15, color: AppColors.white, fontWeight: FontWeight.w400),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ];
                                                                    },
                                                                    onSelected: (value) async {
                                                                      if (value == 0) {
                                                                        await manage_profile_userDetail_Api("${item.userID}");
                                                                        _admin_UserDeatil("${item.userID}");
                                                                      }
                                                                      if (value == 1) {
                                                                        _approveRequest(item.displayName.toString(), item.userID, item.subscription.toString(), item.status.toString());
                                                                        approvalCommentController.clear();
                                                                      }
                                                                      if (value == 2) {
                                                                        _cancelSubscriptionRequest(item.displayName.toString(), item.userID.toString());
                                                                      }
                                                                    })
                                                                    : PopupMenuButton(
                                                                    iconSize: 18,
                                                                    itemBuilder: (context) {
                                                                      return [
                                                                        PopupMenuItem<int>(
                                                                          value: 0,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              CommonText(text: AppString.userDetail, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 1,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(approveIcon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              Center(
                                                                                child: CommonText(text: AppString.approveRequest, fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w500),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 2,
                                                                          child: Container(
                                                                            width: double.infinity,
                                                                            height: 30,
                                                                            color: AppColors.dark_red,
                                                                            child: Center(
                                                                              child: CommonText(text: AppString.cancelSubscription, fontSize: 15, color: AppColors.white, fontWeight: FontWeight.w400),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ];
                                                                    },
                                                                    onSelected: (value) async {
                                                                      if (value == 0) {
                                                                        await manage_profile_userDetail_Api("${item.userID}");
                                                                        _admin_UserDeatil("${item.userID}");
                                                                      }
                                                                      // if (value == 1) {
                                                                      //   _assignTrainer(item.displayName.toString(), item.userID);
                                                                      // }
                                                                      if (value == 1) {
                                                                        _approveRequest(item.displayName.toString(), item.userID, item.subscription.toString(), item.status.toString());
                                                                        approvalCommentController.clear();
                                                                      }
                                                                      if (value == 2) {
                                                                        _cancelSubscriptionRequest(item.displayName.toString(), item.userID.toString());
                                                                      }
                                                                    }),
                                                              )
                                                                  : item.subscription == "Platinum" ||
                                                                  item.subscription == "Gold"
                                                                  ? Container(
                                                                width: 20,
                                                                child: PopupMenuButton(
                                                                    iconSize: 18,
                                                                    itemBuilder: (context) {
                                                                      return [
                                                                        PopupMenuItem<int>(
                                                                          value: 0,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 1,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(addUserIcon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              const CommonText(text: "Change Trainer", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<int>(
                                                                          value: 2,
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(addUserIcon, color: AppColors.black_txcolor),
                                                                              const SizedBox(width: 10),
                                                                              const CommonText(text: "Change Player ID#", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ];
                                                                    },
                                                                    onSelected: (value) async {
                                                                      if (value == 0) {
                                                                        print("My account menu is selected.");
                                                                        await manage_profile_userDetail_Api("${item.userID}");
                                                                        _admin_UserDeatil("${item.userID}");
                                                                      } else if (value == 1) {
                                                                        print("Settings menu is selected.");
                                                                        _changeTrainer("${item.displayName}", "${item.trainerName}", item.userID, item.trainerID.toString());
                                                                        PreferenceUtils.remove("athleteTrainer");
                                                                      } else if (value == 2) {
                                                                        print("Settings menu is selected.");
                                                                        await _changePlayerID("${item.playerId ?? ""}", "${item.userID}");
                                                                      }
                                                                    }),
                                                              )
                                                                  : item.subscription == "Free"
                                                                  ? Container(
                                                                width: 20,
                                                                child: PopupMenuButton(
                                                                  iconSize: 18,
                                                                  itemBuilder: (context) {
                                                                    return [
                                                                      PopupMenuItem<int>(
                                                                        value: 0,
                                                                        child: Row(
                                                                          children: [
                                                                            SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                            const SizedBox(width: 10),
                                                                            const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ];
                                                                  },
                                                                  onSelected: (value) async {
                                                                    if (value == 0) {
                                                                      print("My account menu is selected.");
                                                                      await manage_profile_userDetail_Api("${item.userID}");
                                                                      _admin_UserDeatil("${item.userID}");
                                                                    }
                                                                  },
                                                                ),
                                                              )
                                                                  : Container(
                                                                width: 20,
                                                                child: PopupMenuButton(
                                                                  iconSize: 18,
                                                                  itemBuilder: (context) {
                                                                    return [
                                                                      PopupMenuItem<int>(
                                                                        value: 0,
                                                                        child: Row(
                                                                          children: [
                                                                            SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                            const SizedBox(width: 10),
                                                                            const CommonText(text: "User Details", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ];
                                                                  },
                                                                  onSelected: (value) async {
                                                                    if (value == 0) {
                                                                      print("My account menu is selected.");
                                                                      await manage_profile_userDetail_Api("${item.userID}");
                                                                      _admin_UserDeatil("${item.userID}");
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  )
                                          : Container()
                                      : Container();
                                },
                              );
                            } else if (status_dropdown_value == "Rejected") {
                              return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.only(top: 5),
                                shrinkWrap: true,
                                itemCount: records.length,
                                itemBuilder: (context, index) {
                                  final item = records[index];
                                  DateTime joiningDate = DateTime.parse(
                                      item.joiningDate.toString());
                                  String displayname = "${item.displayName}";
                                  return item.displayName!.toLowerCase().contains(searchString) || item.subscription!.toLowerCase().contains(searchString)
                                      ? item.status == "Rejected"
                                          ? Column(
                                    children: [
                                      if(selectSportsDropDownValue == null)
                                        Container(
                                          margin: const EdgeInsets.only(
                                              bottom: 10,
                                              left: 5,
                                              right: 5),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                    width: 0.1),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    10)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  15.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          CommonText(
                                                              text: displayname
                                                                  .toTitleCase() ??
                                                                  "",
                                                              fontSize: 15,
                                                              color: AppColors
                                                                  .black_txcolor,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "REQUEST DATE : ",
                                                              DateFormat(
                                                                  'yMMMd')
                                                                  .format(
                                                                  joiningDate)),
                                                          const SizedBox(
                                                              height: 8),
                                                          if (item.approvalDate !=
                                                              null)
                                                            _CommonRow(
                                                                "APPROVAL DATE : ",
                                                                DateFormat('yMMMd').format(DateTime.parse(item.approvalDate.toString() ??
                                                                    "")) ??
                                                                    ""),
                                                          if (item.approvalDate ==
                                                              null)
                                                            _CommonRow(
                                                                "APPROVAL DATE : ",
                                                                ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "SUBSCRIPTION : ",
                                                              item.subscription ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "PRICE : ",
                                                              " ${"\$${item.price}" ?? ""}"),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "SOLICITED NAME : ",
                                                              item.solicitedName ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "SPORT : ",
                                                              item.sport ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "TRAINER : ",
                                                              item.trainerName ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          item.age != null
                                                              ? _CommonRow(
                                                              "AGE : ",
                                                              item.age.toString() ??
                                                                  "")
                                                              : _CommonRow(
                                                              "AGE : ",
                                                              ""),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                  height:
                                                                  20,
                                                                  width:
                                                                  64.52,
                                                                  decoration:
                                                                  BoxDecoration(
                                                                    color: item.status ==
                                                                        "Pending"
                                                                        ? AppColors.orange
                                                                        : item.status == "Rejected"
                                                                        ? AppColors.rejected
                                                                        : AppColors.approvedbackground_Color,
                                                                    borderRadius:
                                                                    BorderRadius.circular(16),
                                                                  ),
                                                                  child:
                                                                  Center(
                                                                    child:
                                                                    CommonText(
                                                                      text: item
                                                                          .status
                                                                          .toString(),
                                                                      fontSize:
                                                                      10,
                                                                      color: item.status == "Pending"
                                                                          ? AppColors.onHold
                                                                          : item.status == "Rejected"
                                                                          ? AppColors.onHoldTextColor
                                                                          : AppColors.approvedtext_Color,
                                                                      fontWeight:
                                                                      FontWeight.w400,
                                                                    ),
                                                                  )),
                                                              SizedBox(
                                                                width: 20,
                                                                child:
                                                                PopupMenuButton(
                                                                  iconSize:
                                                                  18,
                                                                  itemBuilder:
                                                                      (context) {
                                                                    return [
                                                                      PopupMenuItem<
                                                                          int>(
                                                                        value:
                                                                        0,
                                                                        child:
                                                                        Row(
                                                                          children: [
                                                                            SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                            const SizedBox(width: 10),
                                                                            const CommonText(text: "Rejected Reason", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ];
                                                                  },
                                                                  onSelected:
                                                                      (value) async {
                                                                    if (value ==
                                                                        0) {
                                                                      print(
                                                                          "My account menu is selected.");
                                                                      await manage_profile_userDetail_Api(
                                                                          "${item.userID}");
                                                                      _admin_RejectedReason(
                                                                          "${item.userID}",
                                                                          "${item.comment}");
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      if(selectSportsDropDownValue == "All Sports")
                                        Container(
                                          margin: const EdgeInsets.only(
                                              bottom: 10,
                                              left: 5,
                                              right: 5),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                    width: 0.1),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    10)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  15.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          CommonText(
                                                              text: displayname
                                                                  .toTitleCase() ??
                                                                  "",
                                                              fontSize: 15,
                                                              color: AppColors
                                                                  .black_txcolor,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "REQUEST DATE : ",
                                                              DateFormat(
                                                                  'yMMMd')
                                                                  .format(
                                                                  joiningDate)),
                                                          const SizedBox(
                                                              height: 8),
                                                          if (item.approvalDate !=
                                                              null)
                                                            _CommonRow(
                                                                "APPROVAL DATE : ",
                                                                DateFormat('yMMMd').format(DateTime.parse(item.approvalDate.toString() ??
                                                                    "")) ??
                                                                    ""),
                                                          if (item.approvalDate ==
                                                              null)
                                                            _CommonRow(
                                                                "APPROVAL DATE : ",
                                                                ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "SUBSCRIPTION : ",
                                                              item.subscription ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "PRICE : ",
                                                              " ${"\$${item.price}" ?? ""}"),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "SOLICITED NAME : ",
                                                              item.solicitedName ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "SPORT : ",
                                                              item.sport ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "TRAINER : ",
                                                              item.trainerName ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          item.age != null
                                                              ? _CommonRow(
                                                              "AGE : ",
                                                              item.age.toString() ??
                                                                  "")
                                                              : _CommonRow(
                                                              "AGE : ",
                                                              ""),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                  height:
                                                                  20,
                                                                  width:
                                                                  64.52,
                                                                  decoration:
                                                                  BoxDecoration(
                                                                    color: item.status ==
                                                                        "Pending"
                                                                        ? AppColors.orange
                                                                        : item.status == "Rejected"
                                                                        ? AppColors.rejected
                                                                        : AppColors.approvedbackground_Color,
                                                                    borderRadius:
                                                                    BorderRadius.circular(16),
                                                                  ),
                                                                  child:
                                                                  Center(
                                                                    child:
                                                                    CommonText(
                                                                      text: item
                                                                          .status
                                                                          .toString(),
                                                                      fontSize:
                                                                      10,
                                                                      color: item.status == "Pending"
                                                                          ? AppColors.onHold
                                                                          : item.status == "Rejected"
                                                                          ? AppColors.onHoldTextColor
                                                                          : AppColors.approvedtext_Color,
                                                                      fontWeight:
                                                                      FontWeight.w400,
                                                                    ),
                                                                  )),
                                                              SizedBox(
                                                                width: 20,
                                                                child:
                                                                PopupMenuButton(
                                                                  iconSize:
                                                                  18,
                                                                  itemBuilder:
                                                                      (context) {
                                                                    return [
                                                                      PopupMenuItem<
                                                                          int>(
                                                                        value:
                                                                        0,
                                                                        child:
                                                                        Row(
                                                                          children: [
                                                                            SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                            const SizedBox(width: 10),
                                                                            const CommonText(text: "Rejected Reason", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ];
                                                                  },
                                                                  onSelected:
                                                                      (value) async {
                                                                    if (value ==
                                                                        0) {
                                                                      print(
                                                                          "My account menu is selected.");
                                                                      await manage_profile_userDetail_Api(
                                                                          "${item.userID}");
                                                                      _admin_RejectedReason(
                                                                          "${item.userID}",
                                                                          "${item.comment}");
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      if(records[index].sport == selectSportsDropDownValue)
                                        Container(
                                          margin: const EdgeInsets.only(
                                              bottom: 10,
                                              left: 5,
                                              right: 5),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                    width: 0.1),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    10)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  15.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          CommonText(
                                                              text: displayname
                                                                  .toTitleCase() ??
                                                                  "",
                                                              fontSize: 15,
                                                              color: AppColors
                                                                  .black_txcolor,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "REQUEST DATE : ",
                                                              DateFormat(
                                                                  'yMMMd')
                                                                  .format(
                                                                  joiningDate)),
                                                          const SizedBox(
                                                              height: 8),
                                                          if (item.approvalDate !=
                                                              null)
                                                            _CommonRow(
                                                                "APPROVAL DATE : ",
                                                                DateFormat('yMMMd').format(DateTime.parse(item.approvalDate.toString() ??
                                                                    "")) ??
                                                                    ""),
                                                          if (item.approvalDate ==
                                                              null)
                                                            _CommonRow(
                                                                "APPROVAL DATE : ",
                                                                ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "SUBSCRIPTION : ",
                                                              item.subscription ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "PRICE : ",
                                                              " ${"\$${item.price}" ?? ""}"),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "SOLICITED NAME : ",
                                                              item.solicitedName ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "SPORT : ",
                                                              item.sport ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "TRAINER : ",
                                                              item.trainerName ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          item.age != null
                                                              ? _CommonRow(
                                                              "AGE : ",
                                                              item.age.toString() ??
                                                                  "")
                                                              : _CommonRow(
                                                              "AGE : ",
                                                              ""),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                  height:
                                                                  20,
                                                                  width:
                                                                  64.52,
                                                                  decoration:
                                                                  BoxDecoration(
                                                                    color: item.status ==
                                                                        "Pending"
                                                                        ? AppColors.orange
                                                                        : item.status == "Rejected"
                                                                        ? AppColors.rejected
                                                                        : AppColors.approvedbackground_Color,
                                                                    borderRadius:
                                                                    BorderRadius.circular(16),
                                                                  ),
                                                                  child:
                                                                  Center(
                                                                    child:
                                                                    CommonText(
                                                                      text: item
                                                                          .status
                                                                          .toString(),
                                                                      fontSize:
                                                                      10,
                                                                      color: item.status == "Pending"
                                                                          ? AppColors.onHold
                                                                          : item.status == "Rejected"
                                                                          ? AppColors.onHoldTextColor
                                                                          : AppColors.approvedtext_Color,
                                                                      fontWeight:
                                                                      FontWeight.w400,
                                                                    ),
                                                                  )),
                                                              SizedBox(
                                                                width: 20,
                                                                child:
                                                                PopupMenuButton(
                                                                  iconSize:
                                                                  18,
                                                                  itemBuilder:
                                                                      (context) {
                                                                    return [
                                                                      PopupMenuItem<
                                                                          int>(
                                                                        value:
                                                                        0,
                                                                        child:
                                                                        Row(
                                                                          children: [
                                                                            SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                            const SizedBox(width: 10),
                                                                            const CommonText(text: "Rejected Reason", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ];
                                                                  },
                                                                  onSelected:
                                                                      (value) async {
                                                                    if (value ==
                                                                        0) {
                                                                      print(
                                                                          "My account menu is selected.");
                                                                      await manage_profile_userDetail_Api(
                                                                          "${item.userID}");
                                                                      _admin_RejectedReason(
                                                                          "${item.userID}",
                                                                          "${item.comment}");
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  )
                                          : Container()
                                      : Container();
                                },
                              );
                            } else if (status_dropdown_value == "Pending") {
                              return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.only(top: 5),
                                shrinkWrap: true,
                                itemCount: records.length,
                                itemBuilder: (context, index) {
                                  final item = records[index];
                                  DateTime joiningDate = DateTime.parse(
                                      item.joiningDate.toString());
                                  String displayname = "${item.displayName}";
                                  return item.displayName!.toLowerCase().contains(searchString) ||
                                          item.subscription!.toLowerCase().contains(searchString)
                                      ? item.status == "Pending"
                                          ? Column(
                                    children: [
                                      if(selectSportsDropDownValue == null)
                                        Container(
                                          margin: const EdgeInsets.only(
                                              bottom: 10,
                                              left: 5,
                                              right: 5),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                    width: 0.1),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    10)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  15.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          CommonText(
                                                              text: displayname
                                                                  .toTitleCase() ??
                                                                  "",
                                                              fontSize: 15,
                                                              color: AppColors
                                                                  .black_txcolor,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "REQUEST DATE : ",
                                                              DateFormat(
                                                                  'yMMMd')
                                                                  .format(
                                                                  joiningDate)),
                                                          const SizedBox(
                                                              height: 8),
                                                          if (item.approvalDate !=
                                                              null)
                                                            _CommonRow(
                                                                "APPROVAL DATE : ",
                                                                DateFormat('yMMMd').format(DateTime.parse(item.approvalDate.toString() ??
                                                                    "")) ??
                                                                    ""),
                                                          if (item.approvalDate ==
                                                              null)
                                                            _CommonRow(
                                                                "APPROVAL DATE : ",
                                                                ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "SUBSCRIPTION : ",
                                                              item.subscription ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "PRICE : ",
                                                              " ${"\$${item.price}" ?? ""}"),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "SOLICITED NAME : ",
                                                              item.solicitedName ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "SPORT : ",
                                                              item.sport ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "TRAINER : ",
                                                              item.trainerName ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          item.age != null
                                                              ? _CommonRow(
                                                              "AGE : ",
                                                              item.age.toString() ??
                                                                  "")
                                                              : _CommonRow(
                                                              "AGE : ",
                                                              ""),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                  height:
                                                                  20,
                                                                  width:
                                                                  64.52,
                                                                  decoration:
                                                                  BoxDecoration(
                                                                    color: item.status ==
                                                                        "Pending"
                                                                        ? AppColors.orange
                                                                        : item.status == "Rejected"
                                                                        ? AppColors.rejected
                                                                        : AppColors.approvedbackground_Color,
                                                                    borderRadius:
                                                                    BorderRadius.circular(16),
                                                                  ),
                                                                  child:
                                                                  Center(
                                                                    child:
                                                                    CommonText(
                                                                      text: item
                                                                          .status
                                                                          .toString(),
                                                                      fontSize:
                                                                      10,
                                                                      color: item.status == "Pending"
                                                                          ? AppColors.onHold
                                                                          : item.status == "Rejected"
                                                                          ? AppColors.onHoldTextColor
                                                                          : AppColors.approvedtext_Color,
                                                                      fontWeight:
                                                                      FontWeight.w400,
                                                                    ),
                                                                  )),
                                                              SizedBox(
                                                                width: 20,
                                                                child:
                                                                PopupMenuButton(
                                                                  iconSize:
                                                                  18,
                                                                  itemBuilder:
                                                                      (context) {
                                                                    return [
                                                                      PopupMenuItem<
                                                                          int>(
                                                                        value:
                                                                        0,
                                                                        child:
                                                                        Row(
                                                                          children: [
                                                                            SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                            const SizedBox(width: 10),
                                                                            const CommonText(text: "Rejected Reason", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ];
                                                                  },
                                                                  onSelected:
                                                                      (value) async {
                                                                    if (value ==
                                                                        0) {
                                                                      print(
                                                                          "My account menu is selected.");
                                                                      await manage_profile_userDetail_Api(
                                                                          "${item.userID}");
                                                                      _admin_RejectedReason(
                                                                          "${item.userID}",
                                                                          "${item.comment}");
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      if(selectSportsDropDownValue == "All Sports")
                                        Container(
                                          margin: const EdgeInsets.only(
                                              bottom: 10,
                                              left: 5,
                                              right: 5),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                    width: 0.1),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    10)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  15.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          CommonText(
                                                              text: displayname
                                                                  .toTitleCase() ??
                                                                  "",
                                                              fontSize: 15,
                                                              color: AppColors
                                                                  .black_txcolor,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "REQUEST DATE : ",
                                                              DateFormat(
                                                                  'yMMMd')
                                                                  .format(
                                                                  joiningDate)),
                                                          const SizedBox(
                                                              height: 8),
                                                          if (item.approvalDate !=
                                                              null)
                                                            _CommonRow(
                                                                "APPROVAL DATE : ",
                                                                DateFormat('yMMMd').format(DateTime.parse(item.approvalDate.toString() ??
                                                                    "")) ??
                                                                    ""),
                                                          if (item.approvalDate ==
                                                              null)
                                                            _CommonRow(
                                                                "APPROVAL DATE : ",
                                                                ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "SUBSCRIPTION : ",
                                                              item.subscription ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "PRICE : ",
                                                              " ${"\$${item.price}" ?? ""}"),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "SOLICITED NAME : ",
                                                              item.solicitedName ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "SPORT : ",
                                                              item.sport ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "TRAINER : ",
                                                              item.trainerName ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          item.age != null
                                                              ? _CommonRow(
                                                              "AGE : ",
                                                              item.age.toString() ??
                                                                  "")
                                                              : _CommonRow(
                                                              "AGE : ",
                                                              ""),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                  height:
                                                                  20,
                                                                  width:
                                                                  64.52,
                                                                  decoration:
                                                                  BoxDecoration(
                                                                    color: item.status ==
                                                                        "Pending"
                                                                        ? AppColors.orange
                                                                        : item.status == "Rejected"
                                                                        ? AppColors.rejected
                                                                        : AppColors.approvedbackground_Color,
                                                                    borderRadius:
                                                                    BorderRadius.circular(16),
                                                                  ),
                                                                  child:
                                                                  Center(
                                                                    child:
                                                                    CommonText(
                                                                      text: item
                                                                          .status
                                                                          .toString(),
                                                                      fontSize:
                                                                      10,
                                                                      color: item.status == "Pending"
                                                                          ? AppColors.onHold
                                                                          : item.status == "Rejected"
                                                                          ? AppColors.onHoldTextColor
                                                                          : AppColors.approvedtext_Color,
                                                                      fontWeight:
                                                                      FontWeight.w400,
                                                                    ),
                                                                  )),
                                                              SizedBox(
                                                                width: 20,
                                                                child:
                                                                PopupMenuButton(
                                                                  iconSize:
                                                                  18,
                                                                  itemBuilder:
                                                                      (context) {
                                                                    return [
                                                                      PopupMenuItem<
                                                                          int>(
                                                                        value:
                                                                        0,
                                                                        child:
                                                                        Row(
                                                                          children: [
                                                                            SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                            const SizedBox(width: 10),
                                                                            const CommonText(text: "Rejected Reason", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ];
                                                                  },
                                                                  onSelected:
                                                                      (value) async {
                                                                    if (value ==
                                                                        0) {
                                                                      print(
                                                                          "My account menu is selected.");
                                                                      await manage_profile_userDetail_Api(
                                                                          "${item.userID}");
                                                                      _admin_RejectedReason(
                                                                          "${item.userID}",
                                                                          "${item.comment}");
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      if(records[index].sport == selectSportsDropDownValue)
                                        Container(
                                          margin: const EdgeInsets.only(
                                              bottom: 10,
                                              left: 5,
                                              right: 5),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                    width: 0.1),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    10)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  15.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          CommonText(
                                                              text: displayname
                                                                  .toTitleCase() ??
                                                                  "",
                                                              fontSize: 15,
                                                              color: AppColors
                                                                  .black_txcolor,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "REQUEST DATE : ",
                                                              DateFormat(
                                                                  'yMMMd')
                                                                  .format(
                                                                  joiningDate)),
                                                          const SizedBox(
                                                              height: 8),
                                                          if (item.approvalDate !=
                                                              null)
                                                            _CommonRow(
                                                                "APPROVAL DATE : ",
                                                                DateFormat('yMMMd').format(DateTime.parse(item.approvalDate.toString() ??
                                                                    "")) ??
                                                                    ""),
                                                          if (item.approvalDate ==
                                                              null)
                                                            _CommonRow(
                                                                "APPROVAL DATE : ",
                                                                ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "SUBSCRIPTION : ",
                                                              item.subscription ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "PRICE : ",
                                                              " ${"\$${item.price}" ?? ""}"),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "SOLICITED NAME : ",
                                                              item.solicitedName ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "SPORT : ",
                                                              item.sport ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          _CommonRow(
                                                              "TRAINER : ",
                                                              item.trainerName ??
                                                                  ""),
                                                          const SizedBox(
                                                              height: 8),
                                                          item.age != null
                                                              ? _CommonRow(
                                                              "AGE : ",
                                                              item.age.toString() ??
                                                                  "")
                                                              : _CommonRow(
                                                              "AGE : ",
                                                              ""),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                  height:
                                                                  20,
                                                                  width:
                                                                  64.52,
                                                                  decoration:
                                                                  BoxDecoration(
                                                                    color: item.status ==
                                                                        "Pending"
                                                                        ? AppColors.orange
                                                                        : item.status == "Rejected"
                                                                        ? AppColors.rejected
                                                                        : AppColors.approvedbackground_Color,
                                                                    borderRadius:
                                                                    BorderRadius.circular(16),
                                                                  ),
                                                                  child:
                                                                  Center(
                                                                    child:
                                                                    CommonText(
                                                                      text: item
                                                                          .status
                                                                          .toString(),
                                                                      fontSize:
                                                                      10,
                                                                      color: item.status == "Pending"
                                                                          ? AppColors.onHold
                                                                          : item.status == "Rejected"
                                                                          ? AppColors.onHoldTextColor
                                                                          : AppColors.approvedtext_Color,
                                                                      fontWeight:
                                                                      FontWeight.w400,
                                                                    ),
                                                                  )),
                                                              SizedBox(
                                                                width: 20,
                                                                child:
                                                                PopupMenuButton(
                                                                  iconSize:
                                                                  18,
                                                                  itemBuilder:
                                                                      (context) {
                                                                    return [
                                                                      PopupMenuItem<
                                                                          int>(
                                                                        value:
                                                                        0,
                                                                        child:
                                                                        Row(
                                                                          children: [
                                                                            SvgPicture.asset(profile_icon, color: AppColors.black_txcolor),
                                                                            const SizedBox(width: 10),
                                                                            const CommonText(text: "Rejected Reason", fontSize: 15, color: AppColors.black_txcolor, fontWeight: FontWeight.w400),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ];
                                                                  },
                                                                  onSelected:
                                                                      (value) async {
                                                                    if (value ==
                                                                        0) {
                                                                      print(
                                                                          "My account menu is selected.");
                                                                      await manage_profile_userDetail_Api(
                                                                          "${item.userID}");
                                                                      _admin_RejectedReason(
                                                                          "${item.userID}",
                                                                          "${item.comment}");
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  )
                                          : Container()
                                      : Container();
                                },
                              );
                            }
                          }
                        } else {
                          return const Center(
                            child: NoDataFound(),
                          );
                        }
                    }
                    return const Center(
                      child: NoDataFound(),
                    );
                  },
                )
              : Container(
                  height: Get.height,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (status_dropdown_value == "All")
                          _isFirstLoadRunning
                              ? Align(
                                  alignment: Alignment.center,
                                  child: CustomLoader(),
                                )
                              : Admin_clgListModel.isEmpty
                                  ? const Align(
                                      alignment: Alignment.center,
                                      child: NoDataFound(),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics: const ClampingScrollPhysics(),
                                      itemCount: Admin_clgListModel.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            if(selectSportsDropDownValue == null)
                                             AdminSerch_Collegerecruiter_Raw(Admin_clgListModel[index]),
                                            if(selectSportsDropDownValue == "All Sports")
                                              AdminSerch_Collegerecruiter_Raw(Admin_clgListModel[index]),
                                            if(Admin_clgListModel[index].sport == selectSportsDropDownValue)
                                              AdminSerch_Collegerecruiter_Raw(Admin_clgListModel[index]),
                                          ],
                                        );
                                      }),
                        if (status_dropdown_value == "Approved")
                          _isFirstLoadRunning
                              ? Align(
                                  alignment: Alignment.center,
                                  child: CustomLoader(),
                                )
                              : Admin_clgListModel.isEmpty
                                  ? const Align(
                                      alignment: Alignment.center,
                                      child: NoDataFound(),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics: const ClampingScrollPhysics(),
                                      //itemCount: datalist.length,
                                      itemCount: Admin_clgListModel.length,
                                      itemBuilder: (context, index) {
                                        return Admin_clgListModel[index].status == "Approved"
                                            ? Column(
                                          children: [
                                            if(selectSportsDropDownValue == null)
                                              AdminSerch_Collegerecruiter_Raw(Admin_clgListModel[index]),
                                            if(selectSportsDropDownValue == "All Sports")
                                              AdminSerch_Collegerecruiter_Raw(Admin_clgListModel[index]),
                                            if(Admin_clgListModel[index].sport == selectSportsDropDownValue)
                                              AdminSerch_Collegerecruiter_Raw(Admin_clgListModel[index]),
                                          ],
                                        )
                                            : Container();
                                      }),
                        if (status_dropdown_value == "Rejected")
                          _isFirstLoadRunning
                              ? Align(
                                  alignment: Alignment.center,
                                  child: CustomLoader(),
                                )
                              : Admin_clgListModel.isEmpty
                                  ? const Align(
                                      alignment: Alignment.center,
                                      child: NoDataFound(),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics: const ClampingScrollPhysics(),
                                      //itemCount: datalist.length,
                                      itemCount: Admin_clgListModel.length,
                                      itemBuilder: (context, index) {
                                        return Admin_clgListModel[index].status == "Rejected"
                                            ? Column(
                                          children: [
                                            if(selectSportsDropDownValue == null)
                                              AdminSerch_Collegerecruiter_Raw(Admin_clgListModel[index]),
                                            if(selectSportsDropDownValue == "All Sports")
                                              AdminSerch_Collegerecruiter_Raw(Admin_clgListModel[index]),
                                            if(Admin_clgListModel[index].sport == selectSportsDropDownValue)
                                              AdminSerch_Collegerecruiter_Raw(Admin_clgListModel[index]),
                                          ],
                                        )
                                            : Container();
                                      }),
                        if (status_dropdown_value == "Pending")
                          _isFirstLoadRunning
                              ? Align(
                                  alignment: Alignment.center,
                                  child: CustomLoader(),
                                )
                              : Admin_clgListModel.isEmpty
                                  ? const Align(
                                      alignment: Alignment.center,
                                      child: NoDataFound(),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics: const ClampingScrollPhysics(),
                                      //itemCount: datalist.length,
                                      itemCount: Admin_clgListModel.length,
                                      itemBuilder: (context, index) {
                                        return Admin_clgListModel[index].status == "Pending"
                                            ? Column(
                                          children: [
                                            if(selectSportsDropDownValue == null)
                                              AdminSerch_Collegerecruiter_Raw(Admin_clgListModel[index]),
                                            if(selectSportsDropDownValue == "All Sports")
                                              AdminSerch_Collegerecruiter_Raw(Admin_clgListModel[index]),
                                            if(Admin_clgListModel[index].sport == selectSportsDropDownValue)
                                              AdminSerch_Collegerecruiter_Raw(Admin_clgListModel[index]),
                                          ],
                                        )
                                            : Container();
                                      }),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  ////////TODO Admin Api Call List /////////
  Widget AdminSerch_Collegerecruiter_Raw(Record record) {
    DateTime joiningDate = DateTime.parse(record.joiningDate.toString());
    String displayname = "${record.displayName}";
    return searchcontroller.text.isEmpty
        ? Container(
            margin: EdgeInsets.only(left: 5, right: 5, top: 5),
            child: Card(
              shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CommonText(
                                text: displayname.toTitleCase() ?? "",
                                fontSize: 15,
                                color: AppColors.black_txcolor,
                                fontWeight: FontWeight.bold),
                            const SizedBox(height: 8),
                            _CommonRow("REQUEST DATE : ",
                                DateFormat('yMMMd').format(joiningDate)),
                            const SizedBox(height: 8),
                            if (record.approvalDate != null)
                              _CommonRow(
                                  "APPROVAL DATE : ",
                                  DateFormat('yMMMd').format(DateTime.parse(
                                          record.approvalDate.toString() ??
                                              "")) ??
                                      ""),
                            if (record.approvalDate == null)
                              _CommonRow("APPROVAL DATE : ", ""),
                            const SizedBox(height: 8),
                            _CommonRow(
                                "SUBSCRIPTION : ", record.subscription ?? ""),
                            const SizedBox(height: 8),
                            _CommonRow(
                                "PRICE : ", " ${"\$${record.price}" ?? ""}"),
                            const SizedBox(height: 8),
                            _CommonRow("SOLICITED NAME : ",
                                record.solicitedName ?? ""),
                            const SizedBox(height: 8),
                            _CommonRow("SPORT : ", record.sport ?? ""),
                            const SizedBox(height: 8),
                            _CommonRow("TRAINER : ", record.trainerName ?? ""),
                            const SizedBox(height: 8),
                            record.age != null
                                ? _CommonRow(
                                    "AGE : ", record.age.toString() ?? "")
                                : _CommonRow("AGE : ", ""),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                    height: 20,
                                    width: 64.52,
                                    decoration: BoxDecoration(
                                      color: record.status == "Pending"
                                          ? AppColors.onHold
                                          : record.status == "Rejected"
                                              ? AppColors.rejected
                                              : AppColors
                                                  .approvedbackground_Color,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Center(
                                      child: CommonText(
                                        text: record.status.toString(),
                                        fontSize: 10,
                                        color: record.status == "Pending"
                                            ? AppColors.orange
                                            : record.status == "Rejected"
                                                ? AppColors.onHoldTextColor
                                                : AppColors.approvedtext_Color,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )),
                                SizedBox(width: 15),
                                record.status == "Rejected"
                                    ? SizedBox(
                                        width: 20,
                                        child: PopupMenuButton(
                                          iconSize: 18,
                                          itemBuilder: (context) {
                                            return [
                                              PopupMenuItem<int>(
                                                value: 0,
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                        profile_icon,
                                                        color: AppColors
                                                            .black_txcolor),
                                                    SizedBox(width: 10),
                                                    CommonText(
                                                        text: "User Details",
                                                        fontSize: 15,
                                                        color: AppColors
                                                            .black_txcolor,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ],
                                                ),
                                              ),
                                            ];
                                          },
                                          onSelected: (value) async {
                                            if (value == 0) {
                                              print(
                                                  "My account menu is selected.");
                                              await manage_profile_userDetail_Api(
                                                  "${record.userId}");
                                              _admin_UserDeatil(
                                                  "${record.userId}");
                                            }
                                          },
                                        ),
                                      )
                                    : SizedBox(
                                        width: 20,
                                        child: PopupMenuButton(
                                          iconSize: 18,
                                          itemBuilder: (context) {
                                            return [
                                              PopupMenuItem<int>(
                                                value: 0,
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                        profile_icon,
                                                        color: AppColors
                                                            .black_txcolor),
                                                    SizedBox(width: 10),
                                                    CommonText(
                                                        text: "User Details",
                                                        fontSize: 15,
                                                        color: AppColors
                                                            .black_txcolor,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuItem<int>(
                                                value: 1,
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                        addUserIcon,
                                                        color: AppColors
                                                            .black_txcolor),
                                                    SizedBox(width: 10),
                                                    CommonText(
                                                        text: "Change Trainer",
                                                        fontSize: 15,
                                                        color: AppColors
                                                            .black_txcolor,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuItem<int>(
                                                value: 2,
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                        addUserIcon,
                                                        color: AppColors
                                                            .black_txcolor),
                                                    SizedBox(width: 10),
                                                    CommonText(
                                                        text:
                                                            "Change Player ID#",
                                                        fontSize: 15,
                                                        color: AppColors
                                                            .black_txcolor,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ],
                                                ),
                                              ),
                                            ];
                                          },
                                          onSelected: (value) async {
                                            if (value == 0) {
                                              print(
                                                  "My account menu is selected.");
                                              await manage_profile_userDetail_Api(
                                                  "${record.userId}");
                                              _admin_UserDeatil(
                                                  "${record.userId}");
                                            } else if (value == 1) {
                                              print(
                                                  "My account menu is selected.");
                                              _changeTrainer(
                                                  "${record.displayName}",
                                                  "${record.trainerName}",
                                                  record.userId,
                                                  record.trainerId.toString());
                                              PreferenceUtils.remove(
                                                  "athleteTrainer");
                                            } else if (value == 2) {
                                              print(
                                                  "My account menu is selected.");
                                              await _changePlayerID(
                                                  "${record.playerId ?? ""}",
                                                  "${record.userId}");
                                            }
                                          },
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        : record.displayName!.toLowerCase().contains(searchString) ||
                record.displayName!.toLowerCase().contains(searchString)
            ? Container(
                margin: EdgeInsets.only(left: 5, right: 5, top: 5),
                child: Card(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(width: 0.1),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CommonText(
                                    text: record.displayName ?? "No Data",
                                    fontSize: 15,
                                    color: AppColors.black_txcolor,
                                    fontWeight: FontWeight.bold),
                                const SizedBox(height: 8),
                                _CommonRow("REQUEST DATE : ",
                                    DateFormat('yMMMd').format(joiningDate)),
                                const SizedBox(height: 8),
                                if (record.approvalDate != null)
                                  _CommonRow(
                                      "APPROVAL DATE : ",
                                      DateFormat('yMMMd').format(DateTime.parse(
                                              record.approvalDate.toString() ??
                                                  "")) ??
                                          ""),
                                if (record.approvalDate == null)
                                  _CommonRow("APPROVAL DATE : ", ""),
                                const SizedBox(height: 8),
                                _CommonRow("SUBSCRIPTION : ",
                                    record.subscription ?? ""),
                                const SizedBox(height: 8),
                                _CommonRow("PRICE : ",
                                    " ${"\$${record.price}" ?? ""}"),
                                const SizedBox(height: 8),
                                _CommonRow("SOLICITED NAME : ",
                                    record.solicitedName ?? ""),
                                const SizedBox(height: 8),
                                _CommonRow("SPORT : ", record.sport ?? ""),
                                const SizedBox(height: 8),
                                _CommonRow(
                                    "TRAINER : ", record.trainerName ?? ""),
                                const SizedBox(height: 8),
                                record.age != null
                                    ? _CommonRow(
                                        "AGE : ", record.age.toString() ?? "")
                                    : _CommonRow("AGE : ", ""),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                        height: 20,
                                        width: 64.52,
                                        decoration: BoxDecoration(
                                          color: record.status == "Pending"
                                              ? AppColors.onHold
                                              : record.status == "Rejected"
                                                  ? AppColors.rejected
                                                  : AppColors
                                                      .approvedbackground_Color,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Center(
                                          child: CommonText(
                                            text: record.status.toString(),
                                            fontSize: 10,
                                            color: record.status == "Pending"
                                                ? AppColors.orange
                                                : record.status == "Rejected"
                                                    ? AppColors.onHoldTextColor
                                                    : AppColors
                                                        .approvedtext_Color,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )),
                                    SizedBox(width: 15),
                                    record.status == "Rejected"
                                        ? SizedBox(
                                            width: 20,
                                            child: PopupMenuButton(
                                              iconSize: 18,
                                              itemBuilder: (context) {
                                                return [
                                                  PopupMenuItem<int>(
                                                    value: 0,
                                                    child: Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                            profile_icon,
                                                            color: AppColors
                                                                .black_txcolor),
                                                        SizedBox(width: 10),
                                                        CommonText(
                                                            text:
                                                                "User Details",
                                                            fontSize: 15,
                                                            color: AppColors
                                                                .black_txcolor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ],
                                                    ),
                                                  ),
                                                ];
                                              },
                                              onSelected: (value) async {
                                                if (value == 0) {
                                                  print(
                                                      "My account menu is selected.");
                                                  await manage_profile_userDetail_Api(
                                                      "${record.userId}");
                                                  _admin_UserDeatil(
                                                      "${record.userId}");
                                                }
                                              },
                                            ),
                                          )
                                        : SizedBox(
                                            width: 20,
                                            child: PopupMenuButton(
                                              iconSize: 18,
                                              itemBuilder: (context) {
                                                return [
                                                  PopupMenuItem<int>(
                                                    value: 0,
                                                    child: Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                            profile_icon,
                                                            color: AppColors
                                                                .black_txcolor),
                                                        SizedBox(width: 10),
                                                        CommonText(
                                                            text:
                                                                "User Details",
                                                            fontSize: 15,
                                                            color: AppColors
                                                                .black_txcolor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ],
                                                    ),
                                                  ),
                                                  PopupMenuItem<int>(
                                                    value: 1,
                                                    child: Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                            addUserIcon,
                                                            color: AppColors
                                                                .black_txcolor),
                                                        SizedBox(width: 10),
                                                        CommonText(
                                                            text:
                                                                "Change Trainer",
                                                            fontSize: 15,
                                                            color: AppColors
                                                                .black_txcolor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ],
                                                    ),
                                                  ),
                                                  PopupMenuItem<int>(
                                                    value: 2,
                                                    child: Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                            addUserIcon,
                                                            color: AppColors
                                                                .black_txcolor),
                                                        SizedBox(width: 10),
                                                        CommonText(
                                                            text:
                                                                "Change Player ID#",
                                                            fontSize: 15,
                                                            color: AppColors
                                                                .black_txcolor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ],
                                                    ),
                                                  ),
                                                ];
                                              },
                                              onSelected: (value) async {
                                                if (value == 0) {
                                                  print(
                                                      "My account menu is selected.");
                                                  await manage_profile_userDetail_Api(
                                                      "${record.userId}");
                                                  _admin_UserDeatil(
                                                      "${record.userId}");
                                                } else if (value == 1) {
                                                  print(
                                                      "My account menu is selected.");
                                                  _changeTrainer(
                                                      "${record.displayName}",
                                                      "${record.trainerName}",
                                                      record.userId,
                                                      record.trainerId
                                                          .toString());
                                                  PreferenceUtils.remove(
                                                      "athleteTrainer");
                                                } else if (value == 2) {
                                                  print(
                                                      "My account menu is selected.");
                                                  await _changePlayerID(
                                                      "${record.playerId ?? ""}",
                                                      "${record.userId}");
                                                }
                                              },
                                            ),
                                          ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Container();
  }


  Future<bool> _approveRequest(String displayName, int? userID, String subscription, String status) async {
    userController.text = displayName;
    final shouldPop = await showDialog(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          elevation: 0.0,
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                            text: AppString.approveRequest,
                            fontSize: 18,
                            color: AppColors.black,
                            fontWeight: FontWeight.bold),
                        const SizedBox(height: 15),
                        const Divider(color: AppColors.grey_hint_color),
                        const SizedBox(height: 10),
                        TextFieldView2(
                          controller: userController,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return AppString.userName_validation;
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          type: TextInputType.text,
                          text: "user",
                        ),
                        subscription == "Gold" || subscription == "Platinum"
                            ? const SizedBox(height: 10)
                            : Container(),
                        subscription == "Gold" || subscription == "Platinum"
                            ? TextFieldView(
                                controller: plyeridController,
                                textInputAction: TextInputAction.next,
                                type: TextInputType.number,
                                text: "Player ID",
                              )
                            : Container(),
                        const SizedBox(height: 10),
                        subscription == "Free"
                            ? Container()
                            : StatefulBuilder(builder: (context, setState) {
                                return DropdownButtonHideUnderline(
                                  child: DropdownButtonFormField2<String>(
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          left: 0,
                                          right: 10,
                                          bottom: 15,
                                          top: 15),
                                      enabledBorder: OutlineInputBorder(
                                          //<-- SEE HERE
                                          borderSide: BorderSide(
                                              color: AppColors.grey_hint_color,
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      errorBorder: OutlineInputBorder(
                                        //<-- SEE HERE
                                        borderSide: BorderSide(
                                            color: AppColors.dark_red,
                                            width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    value: trainer,
                                    isExpanded: true,
                                    validator: (value) =>
                                        value == null ? ' ' : null,
                                    //itemHeight: 50.0,
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey[700]),
                                    items: trainerList?.map((item) {
                                      PreferenceUtils.setString(
                                          "client_trainerID",
                                          item['TrainerID'].toString());
                                      return DropdownMenuItem(
                                        value: item['TrainerID'].toString(),
                                        child: CommonText(
                                            text: item['TrainerName'],
                                            fontSize: 13,
                                            color: AppColors.black,
                                            fontWeight: FontWeight.w500),
                                      );
                                    }).toList(),
                                    hint: const CommonText(
                                        text: "Select Trainer",
                                        fontSize: 15,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w500),
                                    onChanged: (String? newValue) {
                                      setState(() => trainer = newValue);
                                      if (kDebugMode) {
                                        print(trainer.toString());
                                      }
                                    },
                                  ),
                                );
                              }),
                        const SizedBox(height: 10),
                        TextFieldDetailView(
                          controller: approvalCommentController,
                          textInputAction: TextInputAction.next,
                          type: TextInputType.text,
                          text: "Approval Comment",
                        ),
                        const SizedBox(height: 15),
                        const Divider(color: AppColors.grey_hint_color),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const CommonText(
                                  text: "Cancel",
                                  fontSize: 15,
                                  color: AppColors.dark_blue_button_color,
                                  fontWeight: FontWeight.w500),
                            ),
                            GestureDetector(
                              onTap: () {
                                print(
                                    " approve =======<><><> $clientTrainerID");
                                print("$status");
                                print("trainer id ? $trainer");
                                setState(() {
                                  if (_formKey.currentState!.validate()) {
                                    if (subscription == "Free") {
                                      postApproveRequest(context, userID,
                                          status, clientTrainerID.toString());
                                    } else if (subscription == "Gold" ||
                                        subscription == "Platinum") {
                                      postApproveRequest2(
                                          context,
                                          userID,
                                          status,
                                          clientTrainerID.toString(),
                                          plyeridController.text.toString(),
                                          trainer,
                                          approvalCommentController.text ?? "");
                                    } else {
                                      postApproveRequest3(
                                          context,
                                          userID,
                                          status,
                                          trainer,
                                          approvalCommentController.text ?? "");
                                    }
                                  }
                                });
                              },
                              child: Container(
                                height: 35,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: AppColors.dark_blue_button_color,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Center(
                                  child: CommonText(
                                      text: AppString.approved,
                                      fontSize: 15,
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return shouldPop ?? false;
  }

  Widget showlistrolewise() {
    if ((PreferenceUtils.getString('role') == "admin")) {
      return Adminathleterole();
    } else {
      return whole_coaches_widget_main(cIndex);
    }
  }

  Widget whole_coaches_widget_main(countIndex) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                whole_search_widget_coach_athlet(countIndex),
                Coaches_listView_builder(),
              ],
            ),
          ),
        ));
  }

  _buildRow(image, text, color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(image),
        const SizedBox(width: 10),
        Expanded(
          child: CommonText(
            text: text,
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Future<bool> _admin_UserDeatil(String userId) async {
    final shouldPop = await showDialog(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          elevation: 0.0,
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: SingleChildScrollView(
            child: FutureBuilder<ProfileModel?>(
              future: getManageProfile(accessToken, userId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  Container(
                    height: 100,
                    child: const Center(child: Text("No Data Found")),
                  );
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CustomLoader());
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      Userdetails? userdetails = snapshot.data?.userdetails;
                      if (userdetails != null) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(1000.0),
                                    child: CachedNetworkImage(
                                      height: 60,
                                      width: 60,
                                      fit: BoxFit.cover,
                                      imageUrl: "${userdetails.picturePathS3}",
                                      placeholder: (context, url) =>
                                          CustomLoader(),
                                      errorWidget: (context, url, error) =>
                                          SvgPicture.asset(
                                        userProfile_image,
                                        height: 60,
                                        width: 60,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        CommonText(
                                            text: "${userdetails.displayName}",
                                            fontSize: 18,
                                            color: AppColors.black_txcolor,
                                            fontWeight: FontWeight.w500),
                                        const SizedBox(height: 5),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(
                                              locationIcon,
                                              color: AppColors.black,
                                            ),
                                            const SizedBox(width: 3),
                                            Expanded(
                                              child: CommonText(
                                                  text:
                                                      "${userdetails.streetAddress}, ${userdetails.city}, ${userdetails.state}, ${userdetails.zipcode}",
                                                  fontSize: 15,
                                                  color:
                                                      AppColors.black_txcolor,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(children: [
                                          SvgPicture.asset(
                                            emailIcon,
                                            color: AppColors.black,
                                          ),
                                          const SizedBox(width: 3),
                                          CommonText(
                                              text: "${userdetails.userEmail}",
                                              fontSize: 15,
                                              color: AppColors.black_txcolor,
                                              fontWeight: FontWeight.w400)
                                        ]),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              call_icon,
                                              color: AppColors.black,
                                            ),
                                            const SizedBox(width: 3),
                                            CommonText(
                                                text: "${userdetails.contact}",
                                                fontSize: 15,
                                                color: AppColors.black_txcolor,
                                                fontWeight: FontWeight.w400),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Divider(color: AppColors.grey_hint_color),
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      athleteItemList.length.compareTo(0),
                                  itemBuilder: (context, index) {
                                    print(
                                        "List Of tab length ==-===<><. ${athleteItemList.length}");
                                    uniquelist.add(
                                        athleteItemList[index]["displayGroup"]);
                                    print(
                                        "tab length ==-===<><. ${uniquelist}");
                                    var group = groupBy(athleteItemList,
                                            (e) => e["displayGroup"])
                                        .map((key, value) => MapEntry(
                                            key,
                                            value
                                                .map((e) => e["displayGroup"])
                                                .whereNotNull()));

                                    print(">>>>>>>>>>>>> $group");
                                    print(">>>>>>>>>>>>> ${group.length}");
                                    return TabAdminHomeDetailScreen(
                                        userId, group.length, group);
                                  }),
                              const Divider(color: AppColors.grey_hint_color),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 35,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        color: AppColors.dark_blue_button_color,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Center(
                                        child: CommonText(
                                            text: "Close",
                                            fontSize: 15,
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      } else {
                        return const SizedBox(
                          height: 50,
                          child: Center(
                            child: Text("No Data Found"),
                          ),
                        );
                      }
                    } else {
                      return Container(
                        height: 100,
                        child: const Center(
                          child: Text("No Data Found"),
                        ),
                      );
                    }
                }
                return Container(
                  height: 100,
                  child: const Center(
                    child: Text("No Data Found"),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );

    return shouldPop ?? false;
  }

  Future<bool> _admin_RejectedReason(String userId, String comment) async {
    final shouldPop = await showDialog(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          elevation: 0.0,
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CommonText(
                      text: "Rejected Reason",
                      fontSize: 18,
                      color: AppColors.black_txcolor,
                      fontWeight: FontWeight.bold),
                  const SizedBox(height: 10),
                  const Divider(color: AppColors.grey_hint_color),
                  const SizedBox(height: 10),
                  comment != null
                      ? CommonText(
                          text: comment,
                          fontSize: 14,
                          color: AppColors.black_txcolor,
                          fontWeight: FontWeight.w400)
                      : CommonText(
                          text: "not appropriate",
                          fontSize: 14,
                          color: AppColors.black_txcolor,
                          fontWeight: FontWeight.w400),
                  const Divider(color: AppColors.grey_hint_color),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 35,
                          width: 80,
                          decoration: BoxDecoration(
                            color: AppColors.dark_blue_button_color,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: CommonText(
                                text: "Close",
                                fontSize: 15,
                                color: AppColors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    return shouldPop ?? false;
  }

  Future<bool> _changeTrainer(String displayName, String trainerName, int? userID, String? trainerID) async {
    print("trName2 =========>>>> ${trainerName}");
    trainer = null;
    userController.text = displayName;
    final shouldPop = await showDialog(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          elevation: 0.0,
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CommonText(
                            text: "Change Trainer",
                            fontSize: 18,
                            color: AppColors.black,
                            fontWeight: FontWeight.bold),
                        const SizedBox(height: 15),
                        const Divider(color: AppColors.grey_hint_color),
                        const SizedBox(height: 10),
                        TextFieldView2(
                          controller: userController,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return AppString.userName_validation;
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          type: TextInputType.text,
                          text: "user",
                        ),
                        const SizedBox(height: 10),
                        _buildTrainerDropdown(trainerName),
                        const SizedBox(height: 15),
                        const Divider(color: AppColors.grey_hint_color),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const CommonText(
                                  text: "Cancel",
                                  fontSize: 15,
                                  color: AppColors.dark_blue_button_color,
                                  fontWeight: FontWeight.w500),
                            ),
                            GestureDetector(
                              onTap: () {
                                print("trainee =-====>>>> $trainer");
                                print(
                                    "trainee =-====>>>> ${trainerID.toString()}");
                                print("trainee =-====>>>> $userID");
                                print("trainee =-====>>>> $trainerName");
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    Admmingetcollegerecruiters(stDate, edDate);
                                    Coach_athletes_getlist();
                                    COACH_SEARCH_ATHELETE(
                                        request_newpostionselected_multiplevalue_list,
                                        conditionAdd ?? "",
                                        Search_Value_Controller.text);
                                    getAthleteListApi(
                                        accessToken, _page, _limit, "2");
                                    getTrainerList("1");
                                    trainer == null
                                        ? postChangeTrainer(context, userID,
                                            trainerID.toString())
                                        : postChangeTrainer(context, userID,
                                            trainer.toString());
                                  });
                                }
                              },
                              child: Container(
                                height: 35,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: AppColors.dark_blue_button_color,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Center(
                                  child: CommonText(
                                      text: "Change",
                                      fontSize: 15,
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return shouldPop ?? false;
  }

  Future<bool> _changePlayerID(String playerID, String userId) async {
    plyeridController.text = playerID;
    final shouldPop = await showDialog(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          elevation: 0.0,
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CommonText(
                            text: "Change Player ID#",
                            fontSize: 18,
                            color: AppColors.black,
                            fontWeight: FontWeight.bold),
                        const SizedBox(height: 15),
                        const Divider(color: AppColors.grey_hint_color),
                        const SizedBox(height: 10),
                        TextFieldView(
                          controller: plyeridController,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "";
                              // return AppString.playerId_validation;
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          type: TextInputType.number,
                          text: "Player Id",
                        ),
                        const SizedBox(height: 10),
                        const Divider(color: AppColors.grey_hint_color),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const CommonText(
                                  text: "Cancel",
                                  fontSize: 15,
                                  color: AppColors.dark_blue_button_color,
                                  fontWeight: FontWeight.w500),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    postUpdatePlayerId(context,
                                        plyeridController.text, userId);
                                  });
                                }
                              },
                              child: Container(
                                height: 35,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: AppColors.dark_blue_button_color,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Center(
                                  child: CommonText(
                                      text: "Change",
                                      fontSize: 15,
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return shouldPop ?? false;
  }

  Future<bool> _cancelSubscriptionRequest(String displayName, String? userID) async {
    userController.text = displayName;
    final shouldPop = await showDialog(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          elevation: 0.0,
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                            text: AppString.cancelSubscription,
                            fontSize: 18,
                            color: AppColors.black,
                            fontWeight: FontWeight.bold),
                        const SizedBox(height: 15),
                        const Divider(color: AppColors.grey_hint_color),
                        const SizedBox(height: 10),
                        TextFieldView2(
                          controller: userController,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return AppString.userName_validation;
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          type: TextInputType.text,
                          text: "user",
                        ),
                        const SizedBox(height: 10),
                        TextFieldDetailView(
                          controller: approvalCommentController,
                          textInputAction: TextInputAction.next,
                          type: TextInputType.text,
                          text: "Reject Comment",
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        const Divider(color: AppColors.grey_hint_color),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const CommonText(
                                  text: "Cancel",
                                  fontSize: 15,
                                  color: AppColors.dark_blue_button_color,
                                  fontWeight: FontWeight.w500),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    postAdminReject(context, userID,
                                        approvalCommentController.text);
                                  });
                                }
                              },
                              child: Container(
                                height: 35,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: AppColors.dark_red,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: CommonText(
                                      text: AppString.reject,
                                      fontSize: 15,
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return shouldPop ?? false;
  }

  Widget _buildTrainerDropdown(String trName) {
    print("trName =========>>>> ${trName}");
    print("trainer =========>>>> ${trainer}");
    return StatefulBuilder(builder: (context, setState) {
      return Container(
          height: 46,
          //width: 180,
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
              value: trainer,
              underline: Container(),
              isExpanded: true,
              //itemHeight: 50.0,
              style: TextStyle(fontSize: 15.0, color: Colors.grey[700]),
              items: trainerList?.map((item) {
                return DropdownMenuItem(
                  value: item['TrainerID'].toString(),
                  child: CommonText(
                      text: item['TrainerName'],
                      fontSize: 13,
                      color: AppColors.black,
                      fontWeight: FontWeight.w500),
                );
              }).toList(),
              hint: CommonText(
                  text: trName,
                  fontSize: 15,
                  color: AppColors.black,
                  fontWeight: FontWeight.w500),
              onChanged: (String? newValue) {
                setState(() => trainer = newValue);
                PreferenceUtils.setString("athleteTrainer", trainer.toString());
                print(trainer.toString());
              },
            ),
          ));
    });
  }

  Widget Coaches_listView_builder() {
    return _isFirstLoadRunning
        ? Align(
            alignment: Alignment.center,
            child: CustomLoader(),
          )
        : applybuttonvalue == true
            ? Coach_athelete_search_list.isEmpty
                ? const Align(
                    alignment: Alignment.center,
                    child: NoDataFound(),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: Coach_athelete_search_list.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            // Get.to(const CollegeRecruitersDetailPage());
                          },
                          child: Coach_Athelete_SEARCH_Raw(index));
                    })
            : Coach_Athleteslist.isEmpty
                ? const Align(
                    alignment: Alignment.center,
                    child: NoDataFound(),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: Coach_Athleteslist.length,
                    itemBuilder: (context, index) {
                      return Coach_Athelete_Raw(index);
                    });
  }

  Widget Coach_Athelete_Raw(int index) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
        child: Card(
          margin: const EdgeInsets.only(top: 8, bottom: 8),
          shape: RoundedRectangleBorder(
              side: const BorderSide(width: 0.1),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 50,
                  width: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(1000.0),
                    child: CachedNetworkImage(
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                      imageUrl: "${Coach_Athleteslist[index]["image"] ?? ""}",
                      placeholder: (context, url) => CustomLoader(),
                      errorWidget: (context, url, error) => SizedBox(
                          height: 50,
                          width: 50,
                          child: Image.asset(avatarImage)),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, top: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Coach_Athleteslist[index]["plan"] == "Free"
                            ? Row(
                                children: [
                                  Expanded(
                                    child: CommonText(
                                        text: "${Coach_Athleteslist[index]["displayName"]}",
                                            // "${Coach_Athleteslist[index]["firstName"].toString().replaceRange(1, Coach_Athleteslist[index]["firstName"]?.length, "xxxxx")}, "
                                            // "${Coach_Athleteslist[index]["lastName"].toString().replaceRange(1, Coach_Athleteslist[index]["lastName"]?.length, "xx")}",
                                        fontSize: 18,
                                        color: AppColors.black_txcolor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(width: 4),
                                  Coach_Athleteslist[index]["positionPlayed"] !=
                                          null
                                      ? CommonText(
                                          text:
                                              "(${Coach_Athleteslist[index]["positionPlayed"] ?? ""})",
                                          fontSize: 18,
                                          color: AppColors.black_txcolor,
                                          fontWeight: FontWeight.w500)
                                      : Container(),
                                  const SizedBox(width: 4),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.onHold,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: CommonText(
                                          text: "Free",
                                          fontSize: 15,
                                          color: AppColors.orange,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Coach_Athleteslist[index]["isPreferred"] == 0
                                      ? Container()
                                      : Image.asset(
                                          interested_image,
                                          height: 20,
                                          width: 20,
                                        )
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: CommonText(
                                        text: Coach_Athleteslist[index]
                                                ["displayName"] ??
                                            "",
                                        fontSize: 16,
                                        color: AppColors.black_txcolor,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Coach_Athleteslist[index][positionPlayed] !=
                                          null
                                      ? CommonText(
                                          text:
                                              "(${Coach_Athleteslist[index]["positionPlayed"] ?? ""})",
                                          fontSize: 16,
                                          color: AppColors.black_txcolor,
                                          fontWeight: FontWeight.w700)
                                      : Container(),
                                  Coach_Athleteslist[index]["isPreferred"] == 0
                                      ? Container()
                                      : Image.asset(
                                          interested_image,
                                          height: 20,
                                          width: 20,
                                        ),
                                ],
                              ),
                        const SizedBox(height: 5),
                        Coach_Athleteslist[index]["bio"] == ""
                            ? const CommonText(
                                text: "",
                                fontSize: 10,
                                color: AppColors.grey_hint_color,
                                fontWeight: FontWeight.w400)
                            : CommonText(
                                text:
                                    "${Coach_Athleteslist[index]["bio"] ?? ""}",
                                fontSize: 10,
                                color: AppColors.grey_hint_color,
                                fontWeight: FontWeight.w400),
                        const SizedBox(height: 9),
                        Coach_Athleteslist[index]["plan"] == "Free"
                            ? _buildRow(
                                location_icon,
                               "${Coach_Athleteslist[index]["address"]}, ${Coach_Athleteslist[index]["city"]}, ${Coach_Athleteslist[index]["state"]}, ${Coach_Athleteslist[index]["zipcode"]}",
                                AppColors.black_txcolor,
                              )
                            : _buildRow(
                                location_icon,
                                "${Coach_Athleteslist[index]["address"]}, ${Coach_Athleteslist[index]["city"]}, ${Coach_Athleteslist[index]["state"]}, ${Coach_Athleteslist[index]["zipcode"]}" ??
                                    "",
                                AppColors.black_txcolor,
                              ),
                        const SizedBox(height: 7),
                        Coach_Athleteslist[index]["plan"] == "Free"
                            ? _buildRow(
                                call_icon,
                              "${Coach_Athleteslist[index]["contact"] ?? ""}",

                          // "${Coach_Athleteslist[index]["contact"] ?? ""}".replaceRange(5, Coach_Athleteslist[index]["contact"]?.length, "XXXXXXXX"),
                                AppColors.black_txcolor,
                              )
                            : _buildRow(
                                call_icon,
                                "${Coach_Athleteslist[index]["contact"] ?? ""}",
                                AppColors.black_txcolor,
                              ),
                        const SizedBox(height: 10),
                        Column(
                          children: [
                            Row(
                              children: [
                                Coach_Athleteslist[index]["hittingPosition"] !=
                                        null
                                    ? _buildRowPositions(
                                        "Hitting : ",
                                        Coach_Athleteslist[index]
                                            ["hittingPosition"])
                                    : _buildRowPositions("Hitting : ", "N/A"),
                                const SizedBox(width: 10),
                                Coach_Athleteslist[index]["throwingPosition"] !=
                                        null
                                    ? _buildRowPositions(
                                        "Throwing :",
                                        Coach_Athleteslist[index]
                                            ["throwingPosition"])
                                    : _buildRowPositions("Throwing :", "N/A"),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Coach_Athleteslist[index]["educationGpa"] !=
                                        null
                                    ? _buildRowPositions(
                                        "GPA :",
                                        Coach_Athleteslist[index]
                                            ["educationGpa"])
                                    : _buildRowPositions("GPA :", "N/A"),
                                const SizedBox(width: 10),
                                Coach_Athleteslist[index]["educationGpa"] !=
                                        null
                                    ? _buildRowPositions("NCAA ID# :",
                                        Coach_Athleteslist[index]["nCAAID"])
                                    : _buildRowPositions("NCAA ID# :", "N/A"),
                              ],
                            ),
                            SizedBox(height: 5),
                            Coach_Athleteslist[index]["graduatingYear"] != null
                                ? _buildRowPositions(
                                    "Graduating Year : ",
                                    Coach_Athleteslist[index]["graduatingYear"]
                                        .toString())
                                : _buildRowPositions(
                                    "Graduating Year : ", "N/A"),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Coach_Athleteslist[index]["uploadTranscript"] != null
                            ? GestureDetector(
                                onTap: () async {
                                  _permissionReady = await _checkPermission();
                                  if (_permissionReady) {
                                    await _prepareSaveDir();
                                    print("Downloading");
                                    try {
                                      File file = new File(
                                          "${Coach_Athleteslist[index]["uploadTranscript"]}");
                                      var path = file.path;
                                      var filename = path.split("/").last;
                                      print("@@@@@ ${filename}");
                                      await Dio().download(
                                          "${Coach_Athleteslist[index]["uploadTranscript"]}",
                                          _localPath + "/" + "$filename");
                                      MyApplication.getInstance()!
                                          .showInGreenSnackBar(
                                              "Download Completed Please check storage",
                                              context);
                                      print("Download Completed.");
                                    } catch (e) {
                                      print("Download Failed.\n\n" +
                                          e.toString());
                                    }
                                  }
                                },
                                child: const CommonText(
                                    text: "Download Transcript",
                                    fontSize: 13,
                                    color: AppColors.blue_button_Color,
                                    fontWeight: FontWeight.w500),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 13,
                      width: 11,
                      child: !Coach_Athleteslist[index]["isBookMarked"]!
                          ? InkWell(
                              onTap: () {
                                setState(() {
                                  Coach_Athleteslist[index]["isBookMarked"] =
                                      !Coach_Athleteslist[index]
                                          ["isBookMarked"]!;
                                  bookmarklisttickapi(
                                      Coach_Athleteslist[index]["userID"]
                                          .toString(),
                                      context);
                                });
                              },
                              child: Image.asset(collegerecruitersave))
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  Coach_Athleteslist[index]["isBookMarked"] =
                                      !Coach_Athleteslist[index]
                                          ["isBookMarked"]!;
                                  bookmarklisttickapi(
                                      Coach_Athleteslist[index]["userID"]
                                          .toString(),
                                      context);
                                });
                              },
                              child: Image.asset(bookmarktrue)),
                    ),
                    const SizedBox(width: 10),
                    Coach_Athleteslist[index]["plan"] == "Free"
                        ? SizedBox(
                            width: 20,
                            child: PopupMenuButton(
                              padding: EdgeInsets.zero,
                              iconSize: 18,
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem<int>(
                                    value: 0,
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(briefcaseIcon,
                                            color: AppColors.black_txcolor),
                                        const SizedBox(width: 10),
                                        const CommonText(
                                            text: "Athlete Details",
                                            fontSize: 15,
                                            color: AppColors.black_txcolor,
                                            fontWeight: FontWeight.w400),
                                      ],
                                    ),
                                  ),
                                ];
                              },
                              onSelected: (value) async {
                                if (value == 0) {
                                  await manage_profile_userDetail_Api(
                                      Coach_Athleteslist[index]["userID"]
                                          .toString());
                                  _UserDetails(
                                    Coach_Athleteslist[index]["userID"]
                                        .toString(),
                                    Coach_Athleteslist[index]["image"]
                                        .toString(),
                                    Coach_Athleteslist[index]["displayName"]
                                        .toString(),
                                    Coach_Athleteslist[index]["address"]
                                        .toString(),
                                    Coach_Athleteslist[index]["city"]
                                        .toString(),
                                    Coach_Athleteslist[index]["state"]
                                        .toString(),
                                    Coach_Athleteslist[index]["zipcode"]
                                        .toString(),
                                    Coach_Athleteslist[index]["userEmail"]
                                        .toString(),
                                    Coach_Athleteslist[index]["contact"]
                                        .toString(),
                                    Coach_Athleteslist[index]["plan"]
                                        .toString(),
                                    Coach_Athleteslist[index]["firstName"]
                                        .toString(),
                                    Coach_Athleteslist[index]["lastName"]
                                        .toString(),
                                  );
                                }
                              },
                            ),
                          )
                        : SizedBox(
                            width: 20,
                            child: Coach_Athleteslist[index]["playerID"] != null
                                ? PopupMenuButton(
                                    padding: EdgeInsets.zero,
                                    iconSize: 18,
                                    itemBuilder: (context) {
                                      return [
                                        PopupMenuItem<int>(
                                          value: 0,
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                  messageCircleIcon,
                                                  color:
                                                      AppColors.black_txcolor),
                                              const SizedBox(width: 10),
                                              const CommonText(
                                                  text: "Send Message",
                                                  fontSize: 15,
                                                  color:
                                                      AppColors.black_txcolor,
                                                  fontWeight: FontWeight.w400),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem<int>(
                                          value: 1,
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(barchartIcon,
                                                  color:
                                                      AppColors.black_txcolor),
                                              const SizedBox(width: 10),
                                              const CommonText(
                                                  text: "Stats",
                                                  fontSize: 15,
                                                  color:
                                                      AppColors.black_txcolor,
                                                  fontWeight: FontWeight.w400),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem<int>(
                                          value: 2,
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(briefcaseIcon,
                                                  color:
                                                      AppColors.black_txcolor),
                                              const SizedBox(width: 10),
                                              const CommonText(
                                                  text: "Athlete Details",
                                                  fontSize: 15,
                                                  color:
                                                      AppColors.black_txcolor,
                                                  fontWeight: FontWeight.w400),
                                            ],
                                          ),
                                        ),
                                      ];
                                    },
                                    onSelected: (value) async {
                                      if (value == 0) {
                                        SendMessageController.clear();
                                        print(
                                            "plane ==========>>>> ${Coach_Athleteslist[index]["plan"]}");
                                        SendMessagedialog(
                                            Coach_Athleteslist[index]["userID"]
                                                .toString());
                                      } else if (value == 1) {
                                        print("Send Message menu is selected.");
                                        // Coach_Calleage_Stat_Api(Coach_AthletesModel[index].playerID.toString());
                                        College_stats_dialog(
                                            Coach_Athleteslist[index]
                                                    ["playerID"]
                                                .toString());
                                      } else {
                                        await manage_profile_userDetail_Api(
                                            Coach_Athleteslist[index]["userID"]
                                                .toString());
                                        _UserDetails(
                                          Coach_Athleteslist[index]["userID"]
                                              .toString(),
                                          Coach_Athleteslist[index]["image"]
                                              .toString(),
                                          Coach_Athleteslist[index]
                                                  ["displayName"]
                                              .toString(),
                                          Coach_Athleteslist[index]["address"]
                                              .toString(),
                                          Coach_Athleteslist[index]["city"]
                                              .toString(),
                                          Coach_Athleteslist[index]["state"]
                                              .toString(),
                                          Coach_Athleteslist[index]["zipcode"]
                                              .toString(),
                                          Coach_Athleteslist[index]["userEmail"]
                                              .toString(),
                                          Coach_Athleteslist[index]["contact"]
                                              .toString(),
                                          Coach_Athleteslist[index]["plan"]
                                              .toString(),
                                          Coach_Athleteslist[index]["firstName"]
                                              .toString(),
                                          Coach_Athleteslist[index]["lastName"]
                                              .toString(),
                                        );
                                      }
                                    },
                                  )
                                : PopupMenuButton(
                                    padding: EdgeInsets.zero,
                                    iconSize: 18,
                                    itemBuilder: (context) {
                                      return [
                                        PopupMenuItem<int>(
                                          value: 0,
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                  messageCircleIcon,
                                                  color:
                                                      AppColors.black_txcolor),
                                              const SizedBox(width: 10),
                                              const CommonText(
                                                  text: "Send Message",
                                                  fontSize: 15,
                                                  color:
                                                      AppColors.black_txcolor,
                                                  fontWeight: FontWeight.w400),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem<int>(
                                          value: 1,
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(briefcaseIcon,
                                                  color:
                                                      AppColors.black_txcolor),
                                              const SizedBox(width: 10),
                                              const CommonText(
                                                  text: "Athlete Details",
                                                  fontSize: 15,
                                                  color:
                                                      AppColors.black_txcolor,
                                                  fontWeight: FontWeight.w400),
                                            ],
                                          ),
                                        ),
                                      ];
                                    },
                                    onSelected: (value) async {
                                      if (value == 0) {
                                        SendMessageController.clear();
                                        print(
                                            "plane ==========>>>> ${Coach_Athleteslist[index]["plan"]}");
                                        SendMessagedialog(
                                            Coach_Athleteslist[index]["userID"]
                                                .toString());
                                      } else if (value == 1) {
                                        await manage_profile_userDetail_Api(
                                            Coach_Athleteslist[index]["userID"]
                                                .toString());
                                        _UserDetails(
                                          Coach_Athleteslist[index]["userID"]
                                              .toString(),
                                          Coach_Athleteslist[index]["image"]
                                              .toString(),
                                          Coach_Athleteslist[index]
                                                  ["displayName"]
                                              .toString(),
                                          Coach_Athleteslist[index]["address"]
                                              .toString(),
                                          Coach_Athleteslist[index]["city"]
                                              .toString(),
                                          Coach_Athleteslist[index]["state"]
                                              .toString(),
                                          Coach_Athleteslist[index]["zipcode"]
                                              .toString(),
                                          Coach_Athleteslist[index]["userEmail"]
                                              .toString(),
                                          Coach_Athleteslist[index]["contact"]
                                              .toString(),
                                          Coach_Athleteslist[index]["plan"]
                                              .toString(),
                                          Coach_Athleteslist[index]["firstName"]
                                              .toString(),
                                          Coach_Athleteslist[index]["lastName"]
                                              .toString(),
                                        );
                                      }
                                    },
                                  ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Widget Coach_Athelete_SEARCH_Raw(int index) {
    print(
        "athelete listdata ==== >>> ${Coach_athelete_search_list[index]["firstName"]}");
    return Container(
        margin: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
        child: Card(
          margin: const EdgeInsets.only(top: 8, bottom: 8),
          shape: RoundedRectangleBorder(
              side: const BorderSide(width: 0.1),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 50,
                  width: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(1000.0),
                    child: CachedNetworkImage(
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                      imageUrl: "${Coach_athelete_search_list[index]["image"]}",
                      placeholder: (context, url) => CustomLoader(),
                      errorWidget: (context, url, error) => SizedBox(
                          height: 50,
                          width: 50,
                          child: Image.asset(avatarImage)),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, top: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Coach_athelete_search_list[index]["plan"] == "Free"
                            ? Row(
                                children: [
                                  Expanded(
                                    child: CommonText(
                                        text: "${Coach_athelete_search_list[index]["displayName"] ?? ""}",
                                            // "${Coach_athelete_search_list[index]["firstName"].toString().replaceRange(1, Coach_athelete_search_list[index]["firstName"]?.length, "xxxxx")}, "
                                            // "${Coach_athelete_search_list[index]["lastName"].toString().replaceRange(1, Coach_athelete_search_list[index]["lastName"]?.length, "xx")}",
                                        fontSize: 18,
                                        color: AppColors.black_txcolor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(width: 4),
                                  Coach_athelete_search_list[index]
                                              ["positionPlayed"] !=
                                          null
                                      ? CommonText(
                                          text:
                                              "(${Coach_athelete_search_list[index]["positionPlayed"] ?? ""})",
                                          fontSize: 18,
                                          color: AppColors.black_txcolor,
                                          fontWeight: FontWeight.w500)
                                      : Container(),
                                  SizedBox(width: 4),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.onHold,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: CommonText(
                                          text: "Free",
                                          fontSize: 15,
                                          color: AppColors.orange,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  CommonText(
                                      text:
                                          "${Coach_athelete_search_list[index]["displayName"] ?? ""}",
                                      fontSize: 16,
                                      color: AppColors.black_txcolor,
                                      fontWeight: FontWeight.w700),
                                  Coach_athelete_search_list[index]
                                              ["positionPlayed"] !=
                                          null
                                      ? CommonText(
                                          text:
                                              "(${Coach_athelete_search_list[index]["positionPlayed"] ?? ""})",
                                          fontSize: 16,
                                          color: AppColors.black_txcolor,
                                          fontWeight: FontWeight.w700)
                                      : Container(),
                                ],
                              ),
                        const SizedBox(height: 5),
                        Coach_athelete_search_list[index]["bio"] == ""
                            ? const CommonText(
                                text: "",
                                fontSize: 10,
                                color: AppColors.grey_hint_color,
                                fontWeight: FontWeight.w400)
                            : CommonText(
                                text:
                                    "${Coach_athelete_search_list[index]["bio"] ?? ""}",
                                fontSize: 10,
                                color: AppColors.grey_hint_color,
                                fontWeight: FontWeight.w400),
                        const SizedBox(height: 9),
                        Coach_athelete_search_list[index]["plan"] == "Free"
                            ? _buildRow(
                                location_icon,
                          "${Coach_athelete_search_list[index]["address"]}, ${Coach_athelete_search_list[index]["city"]}, ${Coach_athelete_search_list[index]["state"]}, ${Coach_athelete_search_list[index]["zipcode"]}" ??
                              "",
                                // "xxxxxxxxxxxxxxxxxxxxxx, ${Coach_athelete_search_list[index]["city"]}, ${Coach_athelete_search_list[index]["state"]}, xxxxxxxxxx" ??
                                //     "",
                                AppColors.black_txcolor,
                              )
                            : _buildRow(
                                location_icon,
                                "${Coach_athelete_search_list[index]["address"]}, ${Coach_athelete_search_list[index]["city"]}, ${Coach_athelete_search_list[index]["state"]}, ${Coach_athelete_search_list[index]["zipcode"]}" ??
                                    "",
                                AppColors.black_txcolor,
                              ),
                        const SizedBox(height: 7),
                        Coach_athelete_search_list[index]["plan"] == "Free"
                            ? _buildRow(
                                call_icon,
                          "${Coach_athelete_search_list[index]["contact"] ?? ""}",
                          // "${Coach_athelete_search_list[index]["contact"] ?? ""}"
                                //     .replaceRange(5, 14, "XXXXXXXX"),
                                AppColors.black_txcolor,
                              )
                            : _buildRow(
                                call_icon,
                                "${Coach_athelete_search_list[index]["contact"] ?? ""}",
                                AppColors.black_txcolor,
                              ),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildRowPositions(
                                  "Hitting : ",
                                  Coach_athelete_search_list[index]
                                      ["hittingPosition"]),
                              const SizedBox(width: 10),
                              _buildRowPositions(
                                  "Throwing :",
                                  Coach_athelete_search_list[index]
                                      ["throwingPosition"]),
                              const SizedBox(width: 10),
                              _buildRowPositions(
                                  "Graduating Year : ",
                                  Coach_athelete_search_list[index]
                                          ["graduatingYear"]
                                      .toString()),
                              const SizedBox(width: 10),
                              _buildRowPositions(
                                  "GPA :",
                                  Coach_athelete_search_list[index]
                                      ["educationGpa"]),
                            ],
                          ),
                        ),
                        const SizedBox(height: 7),
                        Coach_athelete_search_list[index]["uploadTranscript"] !=
                                null
                            ? GestureDetector(
                                onTap: () async {
                                  _permissionReady = await _checkPermission();
                                  if (_permissionReady) {
                                    await _prepareSaveDir();
                                    print("Downloading");
                                    try {
                                      File file = File(
                                          "${Coach_athelete_search_list[index]["uploadTranscript"]}");
                                      var path = file.path;
                                      var filename = path.split("/").last;
                                      print("@@@@@ ${filename}");
                                      await Dio().download(
                                          "${Coach_athelete_search_list[index]["uploadTranscript"]}",
                                          _localPath + "/" + "$filename");
                                      MyApplication.getInstance()!
                                          .showInGreenSnackBar(
                                              "Download Completed Please check storage",
                                              context);
                                      print("Download Completed.");
                                    } catch (e) {
                                      print("Download Failed.\n\n" +
                                          e.toString());
                                    }
                                  }
                                },
                                child: const CommonText(
                                    text: "Download Transcript",
                                    fontSize: 13,
                                    color: AppColors.blue_button_Color,
                                    fontWeight: FontWeight.w500),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 13,
                      width: 11,
                      child: Coach_athelete_search_list[index]
                                  ["isBookMarked"] ==
                              false
                          //child: datalist[index]["isBookMarked"] == false
                          ? InkWell(
                              onTap: () {
                                setState(() {
                                  Coach_athelete_search_list[index]
                                          ["isBookMarked"] =
                                      !Coach_athelete_search_list[index]
                                          ["isBookMarked"]!;
                                  isbookmarkclick = true;
                                  print(
                                      "this is value of bookmarkclick$isbookmarkclick");
                                  bookmarklisttickapi(
                                      Coach_athelete_search_list[index]
                                              ["userID"]
                                          .toString(),
                                      context);
                                });
                              },
                              child: Image.asset(collegerecruitersave))
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  Coach_athelete_search_list[index]
                                          ["isBookMarked"] =
                                      !Coach_athelete_search_list[index]
                                          ["isBookMarked"]!;
                                  bookmarklisttickapi(
                                      Coach_athelete_search_list[index]
                                              ["userID"]
                                          .toString(),
                                      context);
                                });
                              },
                              child: Image.asset(bookmarktrue)),
                    ),
                    const SizedBox(width: 10),
                    Coach_athelete_search_list[index]["plan"] == "Free"
                        ? SizedBox(
                            width: 20,
                            child: PopupMenuButton(
                              padding: EdgeInsets.zero,
                              iconSize: 18,
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem<int>(
                                    value: 0,
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(briefcaseIcon,
                                            color: AppColors.black_txcolor),
                                        const SizedBox(width: 10),
                                        const CommonText(
                                            text: "Athlete Details",
                                            fontSize: 15,
                                            color: AppColors.black_txcolor,
                                            fontWeight: FontWeight.w400),
                                      ],
                                    ),
                                  ),
                                ];
                              },
                              onSelected: (value) async {
                                if (value == 0) {
                                  await manage_profile_userDetail_Api(
                                      Coach_athelete_search_list[index]
                                              ["userID"]
                                          .toString());
                                  _UserDetails(
                                      Coach_athelete_search_list[index]
                                              ["userID"]
                                          .toString(),
                                      Coach_athelete_search_list[index]["image"]
                                          .toString(),
                                      Coach_athelete_search_list[index]
                                              ["displayName"]
                                          .toString(),
                                      Coach_athelete_search_list[index]
                                              ["address"]
                                          .toString(),
                                      Coach_athelete_search_list[index]["city"]
                                          .toString(),
                                      Coach_athelete_search_list[index]["state"]
                                          .toString(),
                                      Coach_athelete_search_list[index]
                                              ["zipcode"]
                                          .toString(),
                                      Coach_athelete_search_list[index]
                                              ["userEmail"]
                                          .toString(),
                                      Coach_athelete_search_list[index]
                                              ["contact"]
                                          .toString(),
                                      Coach_athelete_search_list[index]
                                              ["plan"]
                                          .toString(),
                                      Coach_athelete_search_list[index]
                                              ["firstName"]
                                          .toString(),
                                      Coach_athelete_search_list[index]
                                              ["lastName"]
                                          .toString());
                                }
                              },
                            ),
                          )
                        : SizedBox(
                            width: 20,
                            child: PopupMenuButton(
                              padding: EdgeInsets.zero,
                              iconSize: 18,
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem<int>(
                                    value: 0,
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(messageCircleIcon,
                                            color: AppColors.black_txcolor),
                                        const SizedBox(width: 10),
                                        const CommonText(
                                            text: "Send Message",
                                            fontSize: 15,
                                            color: AppColors.black_txcolor,
                                            fontWeight: FontWeight.w400),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem<int>(
                                    value: 1,
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(barchartIcon,
                                            color: AppColors.black_txcolor),
                                        const SizedBox(width: 10),
                                        const CommonText(
                                            text: "Stats",
                                            fontSize: 15,
                                            color: AppColors.black_txcolor,
                                            fontWeight: FontWeight.w400),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem<int>(
                                    value: 2,
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(briefcaseIcon,
                                            color: AppColors.black_txcolor),
                                        const SizedBox(width: 10),
                                        const CommonText(
                                            text: "Athlete Details",
                                            fontSize: 15,
                                            color: AppColors.black_txcolor,
                                            fontWeight: FontWeight.w400),
                                      ],
                                    ),
                                  ),
                                ];
                              },
                              onSelected: (value) async {
                                if (value == 0) {
                                  SendMessageController.clear();
                                  SendMessagedialog(
                                      Coach_athelete_search_list[index]
                                              ["userID"]
                                          .toString());
                                } else if (value == 1) {
                                  print("Send Message menu is selected.");
                                  // Coach_Calleage_Stat_Api(Coach_Athletes_Search_Model[index].playerID.toString());
                                  College_stats_dialog(
                                      Coach_athelete_search_list[index]
                                              ["playerID"]
                                          .toString());
                                } else {
                                  await manage_profile_userDetail_Api(
                                      Coach_athelete_search_list[index]
                                              ["userID"]
                                          .toString());
                                  _UserDetails(
                                      Coach_athelete_search_list[index]
                                              ["userID"]
                                          .toString(),
                                      Coach_athelete_search_list[index]["image"]
                                          .toString(),
                                      Coach_athelete_search_list[index]
                                              ["displayName"]
                                          .toString(),
                                      Coach_athelete_search_list[index]
                                              ["address"]
                                          .toString(),
                                      Coach_athelete_search_list[index]["city"]
                                          .toString(),
                                      Coach_athelete_search_list[index]["state"]
                                          .toString(),
                                      Coach_athelete_search_list[index]
                                              ["zipcode"]
                                          .toString(),
                                      Coach_athelete_search_list[index]
                                              ["userEmail"]
                                          .toString(),
                                      Coach_athelete_search_list[index]
                                              ["contact"]
                                          .toString(),
                                      Coach_athelete_search_list[index]
                                              ["plan"]
                                          .toString(),
                                      Coach_athelete_search_list[index]
                                              ["firstName"]
                                          .toString(),
                                      Coach_athelete_search_list[index]
                                              ["lastName"]
                                          .toString());
                                }
                              },
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Future<bool> SendMessagedialog(String userid) async {
    final shouldPop = await showDialog(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          elevation: 0.0,
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            CommonText(
                                text: AppString.sendMessage,
                                fontSize: 18,
                                color: AppColors.black_txcolor,
                                fontWeight: FontWeight.w700),
                            /*InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                              child: SvgPicture.asset(close)),*/
                          ]),
                      const SizedBox(width: 10),
                      const Divider(color: AppColors.grey_hint_color),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const CommonText(
                                text: AppString.sendMessage,
                                fontSize: 15,
                                color: AppColors.grey_text_color,
                                fontWeight: FontWeight.w400),
                            CommonText(
                                text: AppString.msgtxlength,
                                fontSize: 15,
                                color: AppColors.grey_text_color,
                                fontWeight: FontWeight.w400),
                          ]),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: SendMessageController,
                              keyboardType: TextInputType.multiline,
                              maxLength: null,
                              maxLines: 4,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: AppColors.grey_hint_color)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: AppColors.grey_hint_color))),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(color: AppColors.grey_hint_color),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const CommonText(
                                text: "Cancel",
                                fontSize: 18,
                                color: AppColors.dark_blue_button_color,
                                fontWeight: FontWeight.w700),
                          ),
                          Container(
                            width: 150,
                            child: Button(
                              textColor: AppColors.white,
                              text: AppString.sendMessage,
                              color: AppColors.dark_blue_button_color,
                              onClick: () async {
                                SendMessageApi(accessToken, userid.toString(),
                                    SendMessageController.text, context);
                                Navigator.pop(context);
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return shouldPop ?? false;
  }

  _UserDetails(
    String userId,
    String image,
    String displayName,
    String address,
    String city,
    String state,
    String zipcode,
    String userEmail,
    String contact,
    String plan,
    String firstName,
    String lastName,
  ) {
    showDialog(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            elevation: 0.0,
            backgroundColor: Colors.white,
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(1000.0),
                            child: CachedNetworkImage(
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                              imageUrl: "$image",
                              placeholder: (context, url) => CustomLoader(),
                              errorWidget: (context, url, error) =>
                                  SvgPicture.asset(
                                userProfile_image,
                                height: 60,
                                width: 60,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                plan == "Free"
                                    ? CommonText(
                                        text: displayName ?? "",
                                            // "${firstName.replaceRange(1, firstName.length, "xxxxxx")} ${lastName.replaceRange(1, lastName.length, "xxxxxx")}",
                                        fontSize: 18,
                                        color: AppColors.black_txcolor,
                                        fontWeight: FontWeight.w500)
                                    : CommonText(
                                        text: displayName ?? "",
                                        fontSize: 18,
                                        color: AppColors.black_txcolor,
                                        fontWeight: FontWeight.w500),
                                const SizedBox(height: 5),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      locationIcon,
                                      color: AppColors.black,
                                    ),
                                    const SizedBox(width: 3),
                                    Expanded(
                                      child: plan == "Free"
                                          ? CommonText(
                                              text:  "${address ?? " "}, ${city ?? ""}, ${state ?? ""}, ${zipcode ?? ""}",

                                          // "xxxxxxxxxxxxxx, ${city ?? ""}, ${state ?? ""}, xxxxxx",
                                              fontSize: 15,
                                              color: AppColors.black_txcolor,
                                              fontWeight: FontWeight.w400)
                                          : CommonText(
                                              text:
                                                  "${address ?? " "}, ${city ?? ""}, ${state ?? ""}, ${zipcode ?? ""}",
                                              fontSize: 15,
                                              color: AppColors.black_txcolor,
                                              fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(children: [
                                  SvgPicture.asset(
                                    emailIcon,
                                    color: AppColors.black,
                                  ),
                                  const SizedBox(width: 3),
                                  plan == "Free"
                                      ? CommonText(
                                          text: userEmail ?? "",
                                          // userEmail.replaceRange(0, userEmail.length, "xxxxxxxxx@xxxx.com"),
                                          fontSize: 15,
                                          color: AppColors.black_txcolor,
                                          fontWeight: FontWeight.w400)
                                      : CommonText(
                                          text: userEmail ?? "",
                                          fontSize: 15,
                                          color: AppColors.black_txcolor,
                                          fontWeight: FontWeight.w400)
                                ]),
                                const SizedBox(height: 5),
                                Row(children: [
                                  SvgPicture.asset(
                                    call_icon,
                                    color: AppColors.black,
                                  ),
                                  const SizedBox(width: 3),
                                  plan == "Free"
                                      ? CommonText(
                                          text: contact ?? "",
                                          // contact.replaceRange(5, 14, "xxxxxxxx"),
                                          fontSize: 15,
                                          color: AppColors.black_txcolor,
                                          fontWeight: FontWeight.w400)
                                      : CommonText(
                                          text: contact ?? "",
                                          fontSize: 15,
                                          color: AppColors.black_txcolor,
                                          fontWeight: FontWeight.w400)
                                ])
                              ],
                            ),
                          ),
                        ]),
                    const SizedBox(height: 10),
                    const Divider(color: AppColors.grey_hint_color),
                    const SizedBox(height: 5),
                    athleteItemList == 0
                        ? const Align(
                            alignment: Alignment.center,
                            child: Center(child: Text("NO Dat Found")),
                          )
                        : ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: athleteItemList.length.compareTo(0),
                            itemBuilder: (context, index) {
                              print(
                                  "List ==-===<><. ${athleteItemList.length}");
                              // uniquelist.add(athleteItemList[index]["displayGroup"]);
                              var group = groupBy(
                                      athleteItemList, (e) => e["displayGroup"])
                                  .map((key, value) => MapEntry(
                                      key,
                                      value
                                          .map((e) => e["displayGroup"])
                                          .whereNotNull()));
                              print(">>>>>>>>>>>>> ${group.keys}");
                              print("tab length ==-===<><. ${uniquelist}");
                              print(">>>>>>>>>>>>> ${group.length}");
                              return TabAdminHomeDetailScreen(
                                  userId, group.length, group);
                            }),
                    const Divider(color: AppColors.grey_hint_color),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 35,
                            width: 80,
                            decoration: BoxDecoration(
                              color: AppColors.dark_blue_button_color,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Center(
                              child: CommonText(
                                  text: "Close",
                                  fontSize: 15,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
    // final shouldPop = await showDialog(
    //   context: context,
    //   builder: (context) => Padding(
    //     padding: const EdgeInsets.symmetric(horizontal: 10),
    //     child:_isFirstLoadRunning ? CircularProgressIndicator() : Dialog(
    //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    //       elevation: 0.0,
    //       backgroundColor: Colors.white,
    //       insetPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    //       child: SingleChildScrollView(
    //         child: Column(
    //           children: [
    //             item != null ?
    //            ListView.builder(
    //                 physics: NeverScrollableScrollPhysics(),
    //                 shrinkWrap: true,
    //                 itemCount: item.length.compareTo(0),
    //                 itemBuilder: (context, index) {
    //                   return item.length != 0 ?
    //                   Padding(
    //                     padding: const EdgeInsets.symmetric(
    //                         horizontal: 15, vertical: 15),
    //                     child: Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       mainAxisAlignment: MainAxisAlignment.start,
    //                       children: [
    //                         Row(
    //                             crossAxisAlignment: CrossAxisAlignment.start,
    //                             mainAxisAlignment: MainAxisAlignment.start,
    //                             children: [
    //                               ClipRRect(
    //                                 borderRadius: BorderRadius.circular(1000.0),
    //                                 child: CachedNetworkImage(
    //                                   height: 60,
    //                                   width: 60,
    //                                   fit: BoxFit.cover,
    //                                   imageUrl: "${item["picturePathS3"]}",
    //                                   placeholder: (context, url) =>
    //                                       CustomLoader(),
    //                                   errorWidget: (context, url, error) =>
    //                                       SvgPicture.asset(
    //                                         userProfile_image,
    //                                         height: 60,
    //                                         width: 60,
    //                                       ),
    //                                 ),
    //                               ),
    //                               const SizedBox(width: 15),
    //                               Expanded(
    //                                 child: Column(
    //                                   crossAxisAlignment:
    //                                   CrossAxisAlignment.start,
    //                                   children: [
    //                                     CommonText(
    //                                         text: "${item["displayName"]}",
    //                                         fontSize: 18,
    //                                         color: AppColors.black_txcolor,
    //                                         fontWeight: FontWeight.w500),
    //                                     const SizedBox(height: 5),
    //                                     Row(
    //                                       crossAxisAlignment:
    //                                       CrossAxisAlignment.start,
    //                                       children: [
    //                                         SvgPicture.asset(
    //                                           locationIcon,
    //                                           color: AppColors.black,
    //                                         ),
    //                                         const SizedBox(width: 3),
    //                                         // Expanded(
    //                                         //   child: CommonText(
    //                                         //       text: ${Coach_AthletesModel[index].address}, ${Coach_AthletesModel[index].city}, ${Coach_AthletesModel[index].state}, ${Coach_AthletesModel[index].zipcode}",
    //                                         //       fontSize: 15,
    //                                         //       color: AppColors.black_txcolor,
    //                                         //       fontWeight: FontWeight.w400),
    //                                         // ),
    //                                       ],
    //                                     ),
    //                                     const SizedBox(height: 5),
    //                                     Row(children: [
    //                                       SvgPicture.asset(
    //                                         emailIcon,
    //                                         color: AppColors.black,
    //                                       ),
    //                                       const SizedBox(width: 3),
    //                                       CommonText(
    //                                           text: "${item["userEmail"]}",
    //                                           fontSize: 15,
    //                                           color: AppColors.black_txcolor,
    //                                           fontWeight: FontWeight.w400)
    //                                     ]),
    //                                     const SizedBox(height: 5),
    //                                     Row(children: [
    //                                       SvgPicture.asset(
    //                                         call_icon,
    //                                         color: AppColors.black,
    //                                       ),
    //                                       const SizedBox(width: 3),
    //                                       CommonText(
    //                                           text: "${item["contact"]}",
    //                                           fontSize: 15,
    //                                           color: AppColors.black_txcolor,
    //                                           fontWeight: FontWeight.w400)
    //                                     ])
    //                                   ],
    //                                 ),
    //                               )
    //                             ]),
    //                         const SizedBox(height: 10),
    //                         const Divider(color: AppColors.grey_hint_color),
    //                         const SizedBox(height: 5),
    //                         athleteItemList != null ?
    //                         ListView.builder(
    //                             physics: NeverScrollableScrollPhysics(),
    //                             shrinkWrap: true,
    //                             itemCount: athleteItemList.length.compareTo(0),
    //                             itemBuilder: (context, index) {
    //                               print("List Of tab length ==-===<><. ${athleteItemList.length}");
    //                               uniquelist.add(athleteItemList[index]["displayGroup"]);
    //                               print("tab length ==-===<><. ${uniquelist}");
    //                               var group = groupBy(athleteItemList, (e) => e["displayGroup"]).map((key, value) => MapEntry(key, value.map((e) => e["displayGroup"]).whereNotNull()));
    //                               print(">>>>>>>>>>>>> $group");
    //                               print(">>>>>>>>>>>>> ${group.length}");
    //                               return TabAdminHomeDetailScreen(
    //                                   userId, group.length);
    //                             }) : Container(),
    //                         const Divider(color: AppColors.grey_hint_color),
    //                         const SizedBox(height: 10),
    //                         Row(
    //                           mainAxisAlignment: MainAxisAlignment.end,
    //                           children: [
    //                             GestureDetector(
    //                               onTap: () {
    //                                 Navigator.pop(context);
    //                               },
    //                               child: Container(
    //                                 height: 35,
    //                                 width: 80,
    //                                 decoration: BoxDecoration(
    //                                   color: AppColors.dark_blue_button_color,
    //                                   borderRadius: BorderRadius.circular(20),
    //                                 ),
    //                                 child: const Center(
    //                                   child: CommonText(
    //                                       text: "Close",
    //                                       fontSize: 15,
    //                                       color: AppColors.white,
    //                                       fontWeight: FontWeight.w500),
    //                                 ),
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ],
    //                     ),
    //                   ) :
    //                   Container();
    //                 }) : Text("No Data Found"),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    // return shouldPop ?? false;
  }

  Future<bool> College_stats_dialog(String playerId) async {
    print("Id ====>>>> $playerId");
    final shouldPop = await showDialog(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          elevation: 0.0,
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: SingleChildScrollView(
            child: FutureBuilder(
              future: StatsApi(playerId.toString()),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  Container(
                    height: 100,
                    child: const Center(
                      child: Text("No Data Found"),
                    ),
                  );
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CustomLoader());
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      PlayerStats? playerStats = snapshot.data?.playerStats;
                      List<Pitchingstats>? pitchingstatslist =
                          snapshot.data?.playerStats?.pitchingstatslist;
                      List<Battingstats>? battingstatslist =
                          snapshot.data?.playerStats?.battingstatslist;
                      print("pitchingstats =====> ${pitchingstatslist}");
                      print("listBattingStats =====> ${battingstatslist}");
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 15),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const CommonText(
                                      text: AppString.playerstats,
                                      fontSize: 18,
                                      color: AppColors.black_txcolor,
                                      fontWeight: FontWeight.w800),
                                  InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: SvgPicture.asset(close)),
                                ]),
                            const SizedBox(height: 5),
                            const Divider(color: AppColors.grey_hint_color),
                            const SizedBox(height: 15),
                            CommonText(
                                text: "${playerStats?.playername}",
                                fontSize: 16,
                                color: AppColors.stats_title_blue,
                                fontWeight: FontWeight.w700),
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CommonText(
                                    text: AppString.leaugename,
                                    fontSize: 14,
                                    color: AppColors.black_txcolor,
                                    fontWeight: FontWeight.w500),
                                Expanded(
                                  child: Text(
                                    "${playerStats?.leaguename}",
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Montserrat',
                                      color: AppColors.grey_text_color,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CommonText(
                                    text: AppString.teamname,
                                    fontSize: 14,
                                    color: AppColors.black_txcolor,
                                    fontWeight: FontWeight.w500),
                                Expanded(
                                  child: CommonText(
                                      text: "${playerStats?.teamname}",
                                      fontSize: 14,
                                      color: AppColors.grey_text_color,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CommonText(
                                    text: AppString.bats,
                                    fontSize: 14,
                                    color: AppColors.black_txcolor,
                                    fontWeight: FontWeight.w500),
                                Expanded(
                                  child: CommonText(
                                      text: "${playerStats?.bats}",
                                      fontSize: 14,
                                      color: AppColors.grey_text_color,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CommonText(
                                    text: AppString.position_player_stata,
                                    fontSize: 14,
                                    color: AppColors.black_txcolor,
                                    fontWeight: FontWeight.w500),
                                Expanded(
                                  child: CommonText(
                                      text: "${playerStats?.position}",
                                      fontSize: 14,
                                      color: AppColors.grey_text_color,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CommonText(
                                    text: AppString.throws,
                                    fontSize: 14,
                                    color: AppColors.black_txcolor,
                                    fontWeight: FontWeight.w500),
                                Expanded(
                                  child: CommonText(
                                      text: "${playerStats?.throws}",
                                      fontSize: 14,
                                      color: AppColors.grey_text_color,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            battingstatslist != null
                                ? const SizedBox(height: 15)
                                : Container(),
                            battingstatslist != null
                                ? const CommonText(
                                    text: "Batting Stats",
                                    fontSize: 16,
                                    color: AppColors.stats_title_blue,
                                    fontWeight: FontWeight.w800)
                                : Container(),
                            battingstatslist != null
                                ? const SizedBox(height: 5)
                                : Container(),
                            battingstatslist != null
                                ? SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                        showBottomBorder: true,
                                        headingRowColor:
                                            MaterialStateProperty.resolveWith(
                                                (states) =>
                                                    AppColors.grey_hint_color),
                                        columns: _createBattingStatsColumns(),
                                        rows: List.generate(
                                            battingstatslist.length, (index) {
                                          var battingstatsItem =
                                              battingstatslist[index];
                                          if (battingstatsItem != null) {
                                            return DataRow(
                                              cells: [
                                                DataCell(
                                                  CommonText(
                                                      text:
                                                          "${battingstatsItem.name}",
                                                      fontSize: 11,
                                                      color: AppColors
                                                          .black_txcolor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                DataCell(
                                                  CommonText(
                                                      text:
                                                          "${battingstatsItem.ab}",
                                                      fontSize: 11,
                                                      color: AppColors
                                                          .black_txcolor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                DataCell(
                                                  CommonText(
                                                      text:
                                                          "${battingstatsItem.avg}",
                                                      fontSize: 11,
                                                      color: AppColors
                                                          .black_txcolor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                DataCell(
                                                  CommonText(
                                                      text:
                                                          "${battingstatsItem.bb}",
                                                      fontSize: 11,
                                                      color: AppColors
                                                          .black_txcolor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                DataCell(
                                                  CommonText(
                                                      text:
                                                          "${battingstatsItem.bib}",
                                                      fontSize: 11,
                                                      color: AppColors
                                                          .black_txcolor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                DataCell(
                                                  CommonText(
                                                      text:
                                                          "${battingstatsItem.gp}",
                                                      fontSize: 11,
                                                      color: AppColors
                                                          .black_txcolor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                DataCell(
                                                  CommonText(
                                                      text:
                                                          "${battingstatsItem.h}",
                                                      fontSize: 11,
                                                      color: AppColors
                                                          .black_txcolor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                DataCell(
                                                  CommonText(
                                                      text:
                                                          "${battingstatsItem.hr}",
                                                      fontSize: 11,
                                                      color: AppColors
                                                          .black_txcolor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                DataCell(
                                                  CommonText(
                                                      text:
                                                          "${battingstatsItem.r}",
                                                      fontSize: 11,
                                                      color: AppColors
                                                          .black_txcolor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                DataCell(
                                                  CommonText(
                                                      text:
                                                          "${battingstatsItem.rbi}",
                                                      fontSize: 11,
                                                      color: AppColors
                                                          .black_txcolor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                DataCell(
                                                  CommonText(
                                                      text:
                                                          "${battingstatsItem.sb}",
                                                      fontSize: 11,
                                                      color: AppColors
                                                          .black_txcolor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                DataCell(
                                                  CommonText(
                                                      text:
                                                          "${battingstatsItem.so}",
                                                      fontSize: 11,
                                                      color: AppColors
                                                          .black_txcolor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                DataCell(
                                                  CommonText(
                                                      text:
                                                          "${battingstatsItem.trib}",
                                                      fontSize: 11,
                                                      color: AppColors
                                                          .black_txcolor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                DataCell(
                                                  CommonText(
                                                      text:
                                                          "${battingstatsItem.x2b}",
                                                      fontSize: 11,
                                                      color: AppColors
                                                          .black_txcolor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                DataCell(
                                                  CommonText(
                                                      text:
                                                          "${battingstatsItem.x3b}",
                                                      fontSize: 11,
                                                      color: AppColors
                                                          .black_txcolor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            );
                                          } else {
                                            return const DataRow(
                                              cells: [],
                                            );
                                          }
                                        })),
                                  )
                                : Container(),
                            pitchingstatslist != null
                                ? const SizedBox(height: 15)
                                : Container(),
                            pitchingstatslist != null
                                ? const CommonText(
                                    text: "Pitching Stats",
                                    fontSize: 16,
                                    color: AppColors.stats_title_blue,
                                    fontWeight: FontWeight.w800)
                                : Container(),
                            pitchingstatslist != null
                                ? const SizedBox(height: 5)
                                : Container(),
                            pitchingstatslist != null
                                ? SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      showBottomBorder: true,
                                      headingRowColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) =>
                                                  AppColors.grey_hint_color),
                                      columns: _createPitchingStatsColumns(),
                                      rows: List.generate(
                                          pitchingstatslist.length, (index) {
                                        var pitchingstatsItem =
                                            pitchingstatslist[index];
                                        if (pitchingstatsItem != null) {
                                          return DataRow(
                                            cells: [
                                              DataCell(
                                                CommonText(
                                                    text:
                                                        "${pitchingstatsItem.name}",
                                                    fontSize: 11,
                                                    color:
                                                        AppColors.black_txcolor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text:
                                                        "${pitchingstatsItem.bb}",
                                                    fontSize: 11,
                                                    color:
                                                        AppColors.black_txcolor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text:
                                                        "${pitchingstatsItem.er}",
                                                    fontSize: 11,
                                                    color:
                                                        AppColors.black_txcolor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text:
                                                        "${pitchingstatsItem.era}",
                                                    fontSize: 11,
                                                    color:
                                                        AppColors.black_txcolor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text:
                                                        "${pitchingstatsItem.gp}",
                                                    fontSize: 11,
                                                    color:
                                                        AppColors.black_txcolor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text:
                                                        "${pitchingstatsItem.gs}",
                                                    fontSize: 11,
                                                    color:
                                                        AppColors.black_txcolor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text:
                                                        "${pitchingstatsItem.h}",
                                                    fontSize: 11,
                                                    color:
                                                        AppColors.black_txcolor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text:
                                                        "${pitchingstatsItem.ip}",
                                                    fontSize: 11,
                                                    color:
                                                        AppColors.black_txcolor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text:
                                                        "${pitchingstatsItem.l}",
                                                    fontSize: 11,
                                                    color:
                                                        AppColors.black_txcolor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text:
                                                        "${pitchingstatsItem.sho}",
                                                    fontSize: 11,
                                                    color:
                                                        AppColors.black_txcolor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text:
                                                        "${pitchingstatsItem.so}",
                                                    fontSize: 11,
                                                    color:
                                                        AppColors.black_txcolor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text:
                                                        "${pitchingstatsItem.sv}",
                                                    fontSize: 11,
                                                    color:
                                                        AppColors.black_txcolor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              DataCell(
                                                CommonText(
                                                    text:
                                                        "${pitchingstatsItem.w}",
                                                    fontSize: 11,
                                                    color:
                                                        AppColors.black_txcolor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          );
                                        } else {
                                          return const DataRow(
                                            cells: [],
                                          );
                                        }
                                      }),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      );
                    } else {
                      return Container(
                        height: 100,
                        child: const Center(
                          child: Text("No Data Found"),
                        ),
                      );
                    }
                }

                return Container(
                  height: 100,
                  child: const Center(
                    child: NoDataFound(),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
    return shouldPop ?? false;
  }

  _buildRowPositions(title, subTxt) {
    return Row(
      children: [
        CommonText(
            text: title,
            fontSize: 13,
            color: AppColors.black_txcolor,
            fontWeight: FontWeight.w500),
        CommonText(
            text: subTxt ?? "",
            fontSize: 13,
            color: AppColors.black_txcolor,
            fontWeight: FontWeight.normal),
      ],
    );
  }

  List<DataColumn> _createBattingStatsColumns() {
    return const [
      DataColumn(
          label: CommonText(
              text: 'SEASON NAME',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'AB',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'AVG',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'BB',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'BIB',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'GP',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'H',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'HR',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'R',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'RBI',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'SB',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'SO',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'TRIB',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'X_2B',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'X_3B',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
    ];
  }

  List<DataColumn> _createPitchingStatsColumns() {
    return const [
      DataColumn(
          label: CommonText(
              text: 'SEASON NAME',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'BB',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'ER',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'ERA',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'GP',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'GS',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'H',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'IP',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'L',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'SHO',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'SO',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'SV',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
      DataColumn(
          label: CommonText(
              text: 'W',
              fontSize: 12,
              color: AppColors.dark_blue_button_color,
              fontWeight: FontWeight.w600)),
    ];
  }

  Widget whole_search_widget_coach_athlet(countIndex) {
    return Container(
        child: Card(
            margin: const EdgeInsets.only(top: 5, bottom: 0),
            shape: RoundedRectangleBorder(
                side: const BorderSide(width: 0.1),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CommonText(
                            text: AppString.searchfilter,
                            fontSize: 14,
                            color: AppColors.stats_title_blue,
                            fontWeight: FontWeight.w700),
                        //outlinebuton_search_apply()
                        seach_apply_clear_button(),
                      ],
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    roleName == "Coach / Recruiter" ?  checkbox_Interested_IN_MY_College() : Container(),
                    roleName == "Coach / Recruiter" ? SizedBox(height: 20) : Container(),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: MultiSelectDialogField(
                        selectedColor: AppColors.dark_blue_button_color,
                        selectedItemsTextStyle:
                            TextStyle(color: AppColors.black_txcolor),
                        buttonIcon: Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.grey_text_color,
                        ),
                        buttonText: const Text(
                          "Position",
                          style: TextStyle(
                              color: AppColors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                        decoration: BoxDecoration(
                          //color: AppColors.grey_text_color,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(
                            color: AppColors.grey_text_color,
                            width: 0.5,
                          ),
                        ),
                        items: positionPlayedList
                            .map((e) => MultiSelectItem(e, e["name"]))
                            .toList(),
                        listType: MultiSelectListType.LIST,
                        onConfirm: (values) {
                          newpostionselected_multiplevalue_list = values;
                          request_newpostionselected_multiplevalue_list =
                              newpostionselected_multiplevalue_list
                                  .map((e) => (e["name"]))
                                  .toList();
                          setState(() {
                            isSelected == true;
                            print(
                                "####${request_newpostionselected_multiplevalue_list}");
                            print(
                                "####${newpostionselected_multiplevalue_list}");
                            PreferenceUtils.remove("filedName");
                            // PreferenceUtils.remove("value");
                          });
                        },
                      ),
                    ),
                    newpostionselected_multiplevalue_list.isEmpty
                        ? Container()
                        : SizedBox(
                            height: 10,
                          ),
                    //search_additionalfield_add_listviewbuilder(countIndex),
                    newpostionselected_multiplevalue_list.isEmpty
                        ? Container()
                        : search_addtionalfield_raw_addbutton(countIndex),
                  ]),
            )));
  }

  Widget seach_apply_clear_button() {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
       request_newpostionselected_multiplevalue_list.isNotEmpty || newpostionselected_multiplevalue_list.isNotEmpty || _isChecked_Interested_INMyCollege  != true
          ? outlinebuton_search_apply()
          : OutlinedButton(
              child: const CommonText(
                text: "Apply",
                fontSize: 14,
                color: AppColors.dark_blue_button_color,
                fontWeight: FontWeight.w400,
              ),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                side: BorderSide(
                    width: 1.0, color: AppColors.dark_blue_button_color),
              ),
              onPressed: () {}),
      SizedBox(
        width: 5,
      ),
      newpostionselected_multiplevalue_list.isNotEmpty ||  _isChecked_Interested_INMyCollege == true
          ? outlinebuton_search_clear()
          : Container(),
    ]);
  }

  Widget outlinebuton_search_apply() {
    return OutlinedButton(
        child: const CommonText(
          text: "Apply",
          fontSize: 14,
          color: AppColors.dark_blue_button_color,
          fontWeight: FontWeight.w400,
        ),
        style: OutlinedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          side: BorderSide(width: 1.0, color: AppColors.dark_blue_button_color),
        ),
        onPressed: () {
          setState(() {
            if (PreferenceUtils.getString("conditionValue") == 'Equals') {
              conditionAdd = "=";
              print("@@@@@ equal ${conditionAdd.toString()}");
            } else if (PreferenceUtils.getString("conditionValue") ==
                'Not Equals') {
              conditionAdd = "!=";
              print("@@@@@ not equal ${conditionAdd.toString()}");
            } else if (PreferenceUtils.getString("conditionValue") ==
                'Less Equal') {
              conditionAdd = "<=";
              print("@@@@@ less equal ${conditionAdd.toString()}");
            } else if (PreferenceUtils.getString("conditionValue") ==
                'Grater Equal') {
              conditionAdd = ">=";
              print("@@@@@ grater equal ${conditionAdd.toString()}");
            } else if (PreferenceUtils.getString("conditionValue") ==
                'Grater Equal') {
              conditionAdd = ">=";
              print("@@@@@ grater equal ${conditionAdd.toString()}");
            }
            applybuttonvalue = true;
            print("Condition =====>> ${PreferenceUtils.getString("value")}");
            COACH_SEARCH_ATHELETE(request_newpostionselected_multiplevalue_list,
                conditionAdd ?? "", PreferenceUtils.getString("value"));
            /*
            Pitcher - (P)
           Batter - In Field (IF)
           Batter - Out Field (OF)
           Batter - Catcher (C)
           Batter - Universal (U)
            */
            /*
            'Equals', =
            'Not Equals', !=
            'Less Equal',<=
           'Greter Equal',>=
             */
          });
        });
  }

  Widget outlinebuton_search_clear() {
    return OutlinedButton(
        child: const CommonText(
          text: "Clear",
          fontSize: 14,
          color: AppColors.dark_red,
          fontWeight: FontWeight.w400,
        ),
        style: OutlinedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          side: BorderSide(width: 1.0, color: AppColors.dark_red),
        ),
        onPressed: () {
          setState(() {
            search_position_selecte_value = null;
            request_newpostionselected_multiplevalue_list.clear();
            newpostionselected_multiplevalue_list.clear();
            search_additional_counter_list == [0];
            search_field_default_seletected_value = null;
            search_field_seletected_value = null;
            search_position_selecte_value = null;
            search_condition_selected_value = null;
            search_field_other_seletected_value = null;
            Search_Value_Controller.clear();
            applybuttonvalue = false;
            _isChecked_Interested_INMyCollege = false;
            Coach_athletes_getlist();
          });
        });
  }

  String generateRandomId() {
    var uuid = Uuid();

    return uuid.v1();
  }

  Widget search_addtionalfield_raw_addbutton(countIndex) {
    print("list api ===== >>> $search_additional_counter_list");
    print(
        "Search_Value_Controller ==========>>>>  ${Search_Value_Controller.text}");
    print(
        "search_condition_selected_value ==========>>>>  ${search_condition_selected_value.toString()}");
    print(
        "search_field_default_seletected_value ==========>>>>  ${search_field_default_seletected_value.toString()}");
    return Column(
      children: [
        for (int i in search_additional_counter_list) ...[
          AthleteConditionSerchfilter(
            id: generateRandomId(),
            counter: i,
            isaddtap: search_additional_counter_list.length == 1
                ? true
                : i == search_additional_counter_list.last
                    ? true
                    : false,
            closeTap: (i) {
              print("id=======>>> $search_additional_counter_list $i");
              setState(() {
                if (i == 0) {
                  search_additional_counter_list.remove(0);
                }
                search_additional_counter_list.remove(i);
              });
            },
            addTap: (id) {
              setState(() {
                search_additional_counter_list
                    .add(search_additional_counter_list.last + 1);
              });
            },
            filedPlayedList: uniquelist,
            selectedVlue: newpostionselected_multiplevalue_list,
            value: Search_Value_Controller,
            conditionValue: search_condition_selected_value,
            fieldValue: search_field_default_seletected_value,
            // condition : search_condition_selected_value,
            position: request_newpostionselected_multiplevalue_list,
          ),
        ]
      ],
    );
  }

  Widget checkbox_Interested_IN_MY_College() {
    return Container(
      height: 15,
      child: Row(
        children: [
          StatefulBuilder(builder: (context, setState) {
            return Checkbox(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
              onChanged: (bool? value) {
                setState(() {
                  _isChecked_Interested_INMyCollege = value!;
                  print(
                      "this is checkboxvalue==>$_isChecked_Interested_INMyCollege");
                });
              },
              value: _isChecked_Interested_INMyCollege,
              activeColor: Colors.blueAccent,
            );
          }),
          CommonText(
              text: "Interested in my college",
              fontSize: 12,
              color: AppColors.stats_title_blue,
              fontWeight: FontWeight.w600),
        ],
      ),
    );
  }

  ///////TODO Coach ATHELETE MAIN Api //////////

  void Coach_athletes_getlist() async {
    log('this is call admincollege recruiter api call',
        name: "college recruiter");
    setState(() {
      _isFirstLoadRunning = true;
    });
    MyApplication.getInstance()!
        .checkConnectivity(context)
        .then((internet) async {
      if (internet != null && internet) {
        try {
          Dio dio = Dio();
          var response = await dio.post(
              "${AppConstant.Coach_athletes}page=$_page&size=$_limit",
              options: Options(followRedirects: false, headers: {
                "Authorization":
                    "Bearer ${PreferenceUtils.getString("accesstoken")}"
              }));
          if (response.statusCode == 200) {
            print("=========>>>>++++++====${response.data}");
            setState(() {
              Coach_Athleteslist = response.data["result"];
              print("=======this is data${Coach_Athleteslist.toString()}");
              setState(() {
                for (Map<String, dynamic> i in Coach_Athleteslist) {
                  Coach_AthletesModel.add(CoachAteleteResult.fromJson(i));
                }
                _isFirstLoadRunning = false;
                print(
                    "=======this is data list of ${Coach_Athleteslist[0]["isBookMarked"]}");
              });
            });
          } else {
            setState(() => _isFirstLoadRunning = false);
          }
        } catch (e) {
          print(e);
          setState(() => _isFirstLoadRunning = false);
        }
      } else {
        MyApplication.getInstance()!
            .showInSnackBar(AppString.no_connection, context);
      }
    });
  }

  ///////TODO Coach SEARCH Api //////////
  void COACH_SEARCH_ATHELETE(List request_newpostionselected_multiplevalue_list, String? search_condition_selected_value, String text) async {
    dataItem = {
      "field": PreferenceUtils.getString("filedName"),
      "value": text,
      "condition": search_condition_selected_value,
    };
    paramsItem.add(dataItem);
    print("paramsItem =============<><======$paramsItem");
    print("list of Position $request_newpostionselected_multiplevalue_list");
    log('this is call serachCollege recruiter api call',
        name: "college recruiter");
    setState(() {
      _isFirstLoadRunning = true;
    });
    MyApplication.getInstance()!
        .checkConnectivity(context)
        .then((internet) async {
      if (internet != null && internet) {
        try {
          Dio dio = Dio();
          var params = [
            {
              "field": "position",
              "value": request_newpostionselected_multiplevalue_list.toList(),
              "condition": "="
            },
            {
              "field": PreferenceUtils.getString("filedName").toLowerCase(),
              "condition": search_condition_selected_value.toString(),
              "value": PreferenceUtils.getString("value"),
            },
          ];
          print("===>this is params${params.toString()}");
          var response = await dio.post(
              "${AppConstant.COACH_athletesearch}page=$_page&size=$_limit&isPreferred=$_isChecked_Interested_INMyCollege",
              data: params,
              options: Options(followRedirects: false, headers: {
                "Authorization":
                    "Bearer ${PreferenceUtils.getString("accesstoken")}"
              }));
          print("+++=>${response.realUri}");
          if (response.statusCode == 200) {
            setState(() {
              Coach_athelete_search_list = response.data["Data"] ?? [];
              print("=======this is data list COACH_ATHELETE_SEARCH${response.data["Data"]}");
              setState(() {
                for (Map<String, dynamic> i in Coach_athelete_search_list) {
                  Coach_Athletes_Search_Model.add(DataSearch.fromJson(i));
                }
                _isFirstLoadRunning = false;
                print("=======this is data list of single item${Coach_AthletesModel[0].firstName}");
              });

            });
          } else {
            _isFirstLoadRunning = false;
            print("${response.statusCode}");
          }
        } on DioError catch (e) {
          _isFirstLoadRunning = false;
          if (e is DioError) {
            print("this is error==>$e");
          }
        }
      } else {
        _isFirstLoadRunning = false;
        MyApplication.getInstance()?.showInSnackBar(AppString.no_connection, context);
      }
    });
  }

  ///////TODO Admin Api //////////
  void Admmingetcollegerecruiters(String? stDate, String? edDate) async {
    log('this is call admincollege recruiter api call',
        name: "college recruiter");
    setState(() {
      _isFirstLoadRunning = true;
    });
    MyApplication.getInstance()!
        .checkConnectivity(context)
        .then((internet) async {
      if (internet != null && internet) {
        try {
          Dio dio = Dio();
          var params = {
            "roleID": 2,
            "startDate": stDate.toString(),
            "endDate": edDate.toString(),
          };
          var response = await dio.post(
              "${AppConstant.ADMIN_USERS}page=$_page&size=$_limit",
              data: params,
              options: Options(followRedirects: false, headers: {
                "Authorization":
                    "Bearer ${PreferenceUtils.getString("accesstoken")}"
              }));
          if (response.statusCode == 200) {
            print("=======this is data list Athelete ${response.data}");
            setState(() {
              Admin_clglist = response.data["Records"];
              _isFirstLoadRunning = false;
              print("=======this is data list Athelete ${Admin_clglist.toString()}");
              setState(() {
                for (Map<String, dynamic> i in Admin_clglist) {
                  Admin_clgListModel.add(Record.fromJson(i));
                }
                print(
                    "=======this is data list of single item${Admin_clgListModel[0].displayName}");
              });
            });
          } else {
            setState(() => _isFirstLoadRunning = false);
          }
        } catch (e) {
          print(e);
          setState(() => _isFirstLoadRunning = false);
        }
      } else {
        MyApplication.getInstance()!
            .showInSnackBar(AppString.no_connection, context);
      }
    });
  }

  /////TODO  Manageprofile Api /////////

  /////TODO  SelcteSportsList Api /////////
  SelcteSportsList() async {
    log('this is SELECT SPORTS  api call', name: "SELECT SPORTS");
    MyApplication.getInstance()!
        .checkConnectivity(context)
        .then((internet) async {
      if (internet != null && internet) {
        try {
          Dio dio = Dio();
          var response = await dio.get(AppConstant.SELECTSPORTS,
              options: Options(followRedirects: false)
          );
          print("-----SELECT SPORTS URL $response");
          if (response.statusCode == 200) {
            print("+++++SELECT SPORTS Response ${response.data}");
            selectSportsResult = response.data["result"];
            allSportsList = allSports + selectSportsResult;
            print("sports DropDown List ========>>>> $allSportsList");
          } else {
            //setState(() => _isFirstLoadRunning = false);
          }
        } catch (e) {
          print(e);
          //setState(() => _isFirstLoadRunning = false);
        }
      } else {
        MyApplication.getInstance()!
            .showInSnackBar(AppString.no_connection, context);
      }
    });
  }

  manage_profile_userDetail_Api(String? userId) async {
    log('this is Manage_Profile  api call', name: "Manage_Profile");
    _isFirstLoadRunning == true;
    try {
      Dio dio = Dio();
      var response = await dio.get("${AppConstant.mamage_profile}/$userId",
          options: Options(followRedirects: false, headers: {
            "Authorization":
                "Bearer ${PreferenceUtils.getString("accesstoken")}"
          }));
      print("-----this is url $response");
      if (response.statusCode == 200) {
        print("+++++this is manageprofile ${response.data}");
        item = response.data["userdetails"];
        athleteItemList = response.data["attribute"];
        itemData.add(item);
        // uniquelist = response.data["attribute"].where((value) => models.add(value["displayGroup"])).toList();
        print("+++++this unique grop List  ${uniquelist}");
        print("+++++this is item ${response.data["attribute"]}");
        print("+++++ item ${item}");
        print("+++++this uniquelist  ${uniquelist}");
        print("+++++this is item ${response.data["attribute"]}");
      } else if (response.statusCode == 401) {
        return Get.offAll(Loginscreennew());
      } else {
        //setState(() => _isFirstLoadRunning = false);
      }
    } catch (e) {
      print(e);
      //setState(() => _isFirstLoadRunning = false);
    }
  }

  serach_filter_api() async {
    log('this is position-played  api call', name: "position-played");
    _isFirstLoadRunning == true;
    try {
      Dio dio = Dio();
      var response = await dio.get(AppConstant.POSITIONPLAYED,
          options: Options(followRedirects: false, headers: {
            "Authorization":
                "Bearer ${PreferenceUtils.getString("accesstoken")}"
          }));
      print("-----this is url $response");
      if (response.statusCode == 200) {
        print(
            "+++++position-played ${response.data["result"]["positionPlayed"]}");
        // this.allPositionData = groupBy(sortBy(JSON.parse(res.result.positionPlayed), "id"), "name");
        // final parsedJson = jsonEncode(response.data["result"]);
        uniquelist = jsonDecode(response.data["result"]["positionPlayed"]);
        group = groupBy(uniquelist, (e) => e["name"]).map((key, value) =>
            MapEntry(key, value.map((e) => e["name"]).whereNotNull()));
        positionPlayedList = uniquelist.where((postition) => seen.add(postition["name"])).toList();
        // filedPlayedList.add(group);

        filedPlayedList = uniquelist
            .where((fieldPlayList) => seen.add(fieldPlayList["displayName"]))
            .toList();
        print("data =========>>> $uniquelist");
        // positionPlayedList = parsedJsonPosition;
        // positionPlayedList = streetsFromJson;
        print("data2 =========>>> $group");
      } else if (response.statusCode == 401) {
        return Navigator.pop(context);
      } else {
        //setState(() => _isFirstLoadRunning = false);
      }
    } catch (e) {
      print(e);
      //setState(() => _isFirstLoadRunning = false);
    }
  }

  _CommonRow(text, text2) {
    return Row(
      children: [
        CommonText(
            text: text,
            fontSize: 12,
            color: AppColors.black_txcolor,
            fontWeight: FontWeight.bold),
        CommonText(
            text: text2,
            fontSize: 12,
            color: AppColors.black_txcolor,
            fontWeight: FontWeight.w500),
      ],
    );
  }
}
