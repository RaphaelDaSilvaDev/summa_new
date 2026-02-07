import 'package:flutter/material.dart';
import 'package:summa/core/theme/app_colors.dart';
import 'package:summa/core/theme/app_text_styles.dart';
import 'package:summa/core/widgets/Input/date_picker.dart';
import 'package:summa/core/widgets/Input/input_text.dart';

class CreateListDialog extends StatefulWidget {
  const CreateListDialog({super.key, this.name, this.date});

  final String? name;
  final DateTime? date;
  @override
  State<CreateListDialog> createState() => _CreateListDialogState();
}

class _CreateListDialogState extends State<CreateListDialog> {
  late TextEditingController nameController;
  late TextEditingController dateController;
  String? nameError;
  DateTime? lazyDate;
  bool isLoading = false;

  @override
  void initState() {
    nameController = TextEditingController(text: widget.name ?? "");
    dateController = TextEditingController(
      text: widget.date != null
          ? '${widget.date?.day.toString().padLeft(2, "0")}/${widget.date?.month.toString().padLeft(2, "0")}/${widget.date?.year}'
          : "",
    );

    lazyDate = widget.date;
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    dateController.dispose();
    super.dispose();
  }

  void _showDatePicker() async {
    final DateTime? pickedDate = await DatePicker.show(
      context,
      initialDate: lazyDate,
    );

    if (pickedDate != null && mounted) {
      setState(() {
        lazyDate = pickedDate;
        dateController.text =
            '${pickedDate.day.toString().padLeft(2, "0")}/${pickedDate.month.toString().padLeft(2, "0")}/${pickedDate.year}';
      });
    }
  }

  void save() {
    if (nameController.text.isNotEmpty) {
      setState(() {
        nameError = null;
        isLoading = true;
      });
      Navigator.pop(context, (nameController.text, lazyDate));
    } else {
      setState(() {
        nameError = "Campo Obrigatório";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.gray400,
      title: Text('Nova Lista', style: AppTextStyles.headline2),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 156,
        child: Column(
          spacing: 8,
          children: [
            InputTextComponent(
              controller: nameController,
              label: 'Nome da lista',
              errorText: nameError,
              hintText: 'Compra do mês',
              autoFocus: true,
            ),

            InputTextComponent(
              controller: dateController,
              label: 'Previsão de compra',
              hintText: '12/05/2025',
              readOnly: true,
              onTap: _showDatePicker,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => {Navigator.pop(context)},
          child: Text(
            'Cancelar',
            style: AppTextStyles.body.copyWith(color: AppColors.gray100),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.purple),
          onPressed: isLoading ? null : save,
          child: isLoading
              ? SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text('Criar', style: AppTextStyles.body),
        ),
      ],
    );
  }
}
