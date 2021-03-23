import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rtg_app/widgets/text_form_list_field.dart';
import 'package:rtg_app/widgets/text_form_section_label.dart';

class EditRecipeScreen extends StatefulWidget {
  static String id = 'edit_recipe_screen';
  @override
  _EditRecipeState createState() => _EditRecipeState();
}

class _EditRecipeState extends State<EditRecipeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController;
  TextEditingController _sourceController;
  TextEditingController _instructionsController;
  TextEditingController _portionsController;
  TextEditingController _preparationTimeController;
  List<FocusNode> focusNodes;
  List<String> ingredients;
  int textFieldToFocus;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _instructionsController = TextEditingController();
    _sourceController = TextEditingController();
    _portionsController = TextEditingController();
    _preparationTimeController = TextEditingController();
    ingredients = [''];
    textFieldToFocus = -1;
    focusNodes = [FocusNode()];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _instructionsController.dispose();
    _sourceController.dispose();
    _portionsController.dispose();
    _preparationTimeController.dispose();
    focusNodes.forEach((focus) {
      focus.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> fields = [
      TextFormSectionLabelFields('Dados gerais'),
      TextFormField(
        controller: _nameController,
        decoration: const InputDecoration(
          hintText: 'Nome da receita',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Nome da receita',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
      ),
      TextFormField(
        controller: _sourceController,
        decoration: const InputDecoration(
          hintText: 'Receita copiada de',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Fonte',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
      ),
      TextFormField(
        controller: _portionsController,
        decoration: const InputDecoration(
          hintText: 'Serve quantas pessoas',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Porções',
        ),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
      ),
      TextFormField(
        controller: _preparationTimeController,
        decoration: const InputDecoration(
          hintText: 'Tempo (minutos)',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Tempo de preparo (minutos)',
        ),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
      ),
      TextFormSectionLabelFields('Ingredientes'),
    ];

    ingredients.asMap().forEach((index, value) {
      fields.add(TextFormListFields(
        index: index,
        initValue: ingredients[index],
        canBeRemoved: ingredients.length == 1,
        onChanged: (i, v) {
          ingredients[i] = v;
        },
        onAddNewField: (i) {
          ingredients.insert(i + 1, '');
          focusNodes.insert(i + 1, FocusNode());
          textFieldToFocus = i + 1;
          setState(() {});
        },
        onRemoveField: (i) {
          ingredients.removeAt(i);
          focusNodes[i].unfocus();
          focusNodes.removeAt(i);

          textFieldToFocus = -1;
          setState(() {});
        },
        focusNode: focusNodes[index],
      ));
    });

    if (textFieldToFocus != -1) {
      focusNodes[textFieldToFocus].requestFocus();
    }

    fields.addAll([
      TextFormSectionLabelFields('Como fazer'),
      TextFormField(
        controller: _instructionsController,
        minLines: 6,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: const InputDecoration(
          hintText: 'Intruções de como fazer a receita',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Instruções',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
      ),
    ]);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).new_recipe),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('save recipe');
          if (_formKey.currentState.validate()) {
            // Process data.
          }
        },
        child: Icon(Icons.done),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          child: ListView(
            padding: EdgeInsets.all(5),
            shrinkWrap: true,
            children: fields,
          ),
        ),
      ),
    );
  }
}
