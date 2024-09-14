



import 'package:flutter/material.dart';

class ClientButton extends StatefulWidget {
  final String label;
  final void Function() onClick;
  const ClientButton({required this.label,required this.onClick,super.key});

  @override
  State<ClientButton> createState() => _ClientButtonState();
}

class _ClientButtonState extends State<ClientButton> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity*0.8,
        height: 50,
        child: ElevatedButton(
           style: ElevatedButton.styleFrom(
             backgroundColor: Colors.purple,
             foregroundColor: Colors.white,
             textStyle: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(4),
             )
           ),
            onPressed: widget.onClick,
            child: Text(widget.label)),
      ),
    );
  }
}
