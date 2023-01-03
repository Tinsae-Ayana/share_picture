import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_picture/authentication/providers/auth_provider.dart';
import 'package:share_picture/post/providers/post_provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _capitonTextEditingController = TextEditingController();
  bool isLoading = false;

  Future<void> selectImage(context) async {
    final picker = ImagePicker();
    final xFile = await picker.pickImage(source: ImageSource.gallery);
    final imageFile = await xFile!.readAsBytes();
    Provider.of<PostProvider>(context, listen: false)
        .changeImageFile(imageFile);
  }

  _onShareButtenPress(context) async {
    if (Provider.of<PostProvider>(context, listen: false).imageFile != null) {
      setState(() {
        isLoading = true;
      });
      Provider.of<PostProvider>(context, listen: false)
          .changeCaption(_capitonTextEditingController.text);
      Provider.of<PostProvider>(context, listen: false)
          .postToFirebase()
          .then((value) {
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //     duration: Duration(seconds: 1), content: Text('Nothing to share')));
        setState(() {
          isLoading = false;
        });
        _capitonTextEditingController.clear();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _capitonTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        title: const Text('New Post'),
        actions: [
          TextButton(
              onPressed: () {
                _onShareButtenPress(context);
              },
              child: const Text('Share', style: TextStyle(fontSize: 18)))
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isLoading
                  ? const SizedBox(height: 2, child: LinearProgressIndicator())
                  : const SizedBox(),
              const SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user!.profilePhoto),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: TextField(
                      controller: _capitonTextEditingController,
                      autocorrect: true,
                      maxLines: 2,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Write caption...'),
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        await selectImage(context);
                      },
                      icon: const Icon(Icons.add_a_photo_outlined))
                ],
              ),
              Selector<PostProvider, Uint8List?>(
                selector: (p0, p1) => p1.imageFile,
                builder: ((context, value, child) {
                  return SizedBox(
                      width: width * 0.5,
                      height: 0.4 * height,
                      child: value == null ? null : Image.memory(value));
                }),
              ),
            ]),
      ),
    );
  }
}
