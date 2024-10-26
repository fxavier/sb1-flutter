import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/features/categories/models/category.dart';
import 'package:flutter_ecommerce/features/categories/models/category_image.dart';
import 'package:flutter_ecommerce/features/categories/models/image_size.dart';

class CategoryFormDialog extends StatefulWidget {
  final Category? category;
  final Function(Category) onSubmit;

  const CategoryFormDialog({
    super.key,
    this.category,
    required this.onSubmit,
  });

  @override
  State<CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends State<CategoryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _imageUrl;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _nameController.text = widget.category!.name;
      _descriptionController.text = widget.category!.description ?? '';
      _imageUrl = widget.category!.image.url;
      _isActive = widget.category!.isActive;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.category == null ? 'Create Category' : 'Edit Category',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Image URL',
                        border: OutlineInputBorder(),
                      ),
                      initialValue: _imageUrl,
                      onChanged: (value) => setState(() => _imageUrl = value),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an image URL';
                        }
                        return null;
                      },
                    ),
                  ),
                  if (_imageUrl != null && _imageUrl!.isNotEmpty) ...[
                    const SizedBox(width: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        _imageUrl!,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Active'),
                value: _isActive,
                onChanged: (value) => setState(() => _isActive = value),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final category = Category(
                          id: widget.category?.id ?? '',
                          name: _nameController.text,
                          description: _descriptionController.text.isEmpty
                              ? null
                              : _descriptionController.text,
                          image: CategoryImage(
                            id: widget.category?.image.id ?? '',
                            url: _imageUrl!,
                            thumbnail: ImageSize(
                              url: _imageUrl!,
                              width: 100,
                              height: 100,
                            ),
                            medium: ImageSize(
                              url: _imageUrl!,
                              width: 300,
                              height: 300,
                            ),
                            large: ImageSize(
                              url: _imageUrl!,
                              width: 800,
                              height: 800,
                            ),
                          ),
                          isActive: _isActive,
                        );
                        widget.onSubmit(category);
                        Navigator.pop(context);
                      }
                    },
                    child: Text(widget.category == null ? 'Create' : 'Update'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}