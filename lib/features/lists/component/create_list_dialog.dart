import 'package:flutter/material.dart';
import 'package:summa/core/theme/app_colors.dart';
import 'package:summa/core/theme/app_text_styles.dart';
import 'package:summa/core/widgets/Input/date_picker.dart';
import 'package:summa/core/widgets/Input/input_text.dart';

class CreateListDialog extends StatefulWidget {
  const CreateListDialog({super.key});

  @override
  State<CreateListDialog> createState() => _CreateListDialogState();
}

class _CreateListDialogState extends State<CreateListDialog> {
  final nameController = TextEditingController();
  final dateController = TextEditingController();
  DateTime? lazyDate;

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

  @override
  void dispose() {
    nameController.dispose();
    dateController.dispose();
    super.dispose();
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
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancelar',
            style: AppTextStyles.body.copyWith(color: AppColors.gray100),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.purple),
          onPressed: () {
            if (nameController.text.isNotEmpty) {
              Navigator.pop(context, (nameController.text, lazyDate));
            }
          },
          child: Text('Criar', style: AppTextStyles.body),
        ),
      ],
    );
  }
}
