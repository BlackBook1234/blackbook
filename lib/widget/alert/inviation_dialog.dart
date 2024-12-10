import 'package:black_book/api/component/api_error.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/models/invitaion/response.dart';
import 'package:black_book/widget/alert/component/buttons.dart';
import 'package:black_book/widget/alert/mixin_dialog.dart';
import 'package:flutter/material.dart';

class InvitationDialog extends StatefulWidget {
  const InvitationDialog({super.key, required this.res});
  final InvitationResponse res;

  @override
  State<InvitationDialog> createState() => _InvitationDialogState();
}

class _InvitationDialogState extends State<InvitationDialog>
    with BaseStateMixin {
  double length = 120;
  final List<String> list = [];
  Future<void> _transferDataSend(int id) async {
    try {
      await api.approveInvation(id);
      Navigator.pop(context);
    } on APIError catch (e) {
      showErrorDialog(e.message);
    }
  }

  @override
  void initState() {
    setState(() {
      length = (widget.res.data ?? list).length * 120;
      if (length > 480) {
        length = 480;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Container(
        height: length,
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: SizedBox(
                      height: 40,
                      width: 40,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: Image.asset("assets/images/mainLogo.png",
                              fit: BoxFit.cover)))),
              const Divider(color: kTextMedium),
              SizedBox(
                height: 40,
                child: BlackBookButton(
                  
                  width: double.infinity,
                  onPressed: () {
                    _transferDataSend(-1);
                  },
                  child: const Text("Шууд нэвтрэх"),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.res.data!.length,
                  itemBuilder: (context, index) {
                    if (widget.res.data![index].id == -1) {
                      return const SizedBox.shrink();
                    }
                    return SizedBox(
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 200,
                            child: Text(
                              widget.res.data![index].text,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: kTextMedium),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                            child: BlackBookButton(
                              color: Colors.grey.withOpacity(0.5),
                              onPressed: () {
                                _transferDataSend(widget.res.data![index].id);
                              },
                              child: const Text(
                                "Урьсан",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
