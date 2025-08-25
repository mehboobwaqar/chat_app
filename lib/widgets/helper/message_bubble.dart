import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

bool isOnlyEmojis(String text) {
  final emojiRegex = RegExp(
    r'^(?:'
    r'[\u{1F1E6}-\u{1F1FF}]'            // flags
    r'|[\u{1F300}-\u{1F5FF}]'           // symbols & pictographs
    r'|[\u{1F600}-\u{1F64F}]'           // emoticons
    r'|[\u{1F680}-\u{1F6FF}]'           // transport & map symbols
    r'|[\u{1F700}-\u{1F77F}]'           // alchemical symbols
    r'|[\u{1F780}-\u{1F7FF}]'           // geometric shapes extended
    r'|[\u{1F800}-\u{1F8FF}]'           // arrows-C
    r'|[\u{1F900}-\u{1F9FF}]'           // supplemental symbols
    r'|[\u{1FA00}-\u{1FA6F}]'           // chess, symbols
    r'|[\u{1FA70}-\u{1FAFF}]'           // pictographs extended-A
    r'|[\u{2600}-\u{26FF}]'             // misc symbols
    r'|[\u{2700}-\u{27BF}]'             // dingbats
    r'|[\u{FE00}-\u{FE0F}]'             // variation selectors
    r'|[\u{200D}]'                      // ZWJ
    r'|[\u{1F018}-\u{1F270}]'           // asian chars
    r'|[\u{238C}-\u{2454}]'             // misc technical
    r')+$',
    unicode: true,
  );
  return emojiRegex.hasMatch(text.trim());
}

class MessageBubble extends StatelessWidget {
  const MessageBubble.first({
    super.key,
    required this.username,
    required this.message,
    required this.isMe,
    required this.messageId,
    required this.onDelete,
    required this.timestamp,
    required this.onEdit,
  }) : isFirstInSequence = true;

  const MessageBubble.next({
    super.key,
    required this.message,
    required this.isMe,
    required this.messageId,
    required this.timestamp,
    required this.onDelete,
    required this.onEdit,
  })  : isFirstInSequence = false,
        username = null;

  final bool isFirstInSequence;
  final String? username;
  final String message;
  final bool isMe;
  final String messageId;
  final DateTime timestamp;

  final VoidCallback onDelete;
  final Function(String) onEdit; 

  @override
  Widget build(BuildContext context) {
    final onlyEmoji = isOnlyEmojis(message);
    final timeString = DateFormat('hh:mm a').format(timestamp);

    return GestureDetector(
      onLongPress: isMe
          ? () {
              _showOptions(context);
            }
          : null,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe) const SizedBox(width: 40), // avatar space
            Flexible(
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (isFirstInSequence && username != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        username!,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isMe
                              ? const Color.fromARGB(255, 79, 99, 107)
                              : Colors.deepPurple,
                        ),
                      ),
                    ),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 260),
                    padding: onlyEmoji
                        ? const EdgeInsets.all(0)
                        : const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 14),
                    decoration: onlyEmoji
                        ? null
                        : BoxDecoration(
                            gradient: isMe
                                ? LinearGradient(
                                    colors: [
                                      Colors.blue.shade400,
                                      const Color.fromARGB(255, 28, 127, 214),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : LinearGradient(
                                    colors: [
                                      Colors.grey.shade300,
                                      const Color.fromARGB(255, 192, 191, 191),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  !isMe && isFirstInSequence ? 0 : 16),
                              topRight: Radius.circular(
                                  isMe && isFirstInSequence ? 0 : 16),
                              bottomLeft: const Radius.circular(16),
                              bottomRight: const Radius.circular(16),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Text(
                            message,
                            style: TextStyle(
                              fontSize: onlyEmoji ? 32 : 15,
                              color: onlyEmoji
                                  ? null
                                  : (isMe ? Colors.white : Colors.black87),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          timeString,
                          style: TextStyle(
                            fontSize: 11,
                            color: onlyEmoji 
    ? Colors.black54 
    : (isMe ? Colors.white70 : Colors.black54),

                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (isMe) const SizedBox(width: 40),
          ],
        ),
      ),
    );
  }

  void _showOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent, // 👈 transparent for rounded corners
    builder: (ctx) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Small handle bar
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 16),

            // Title
            const Text(
              "Choose an Option ✨",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 16),

            // Edit option
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade50,
                child: const Icon(Icons.edit, color: Colors.blue),
              ),
              title: const Text("Edit Message"),
              onTap: () {
                Navigator.pop(ctx);
                _showEditDialog(context);
              },
            ),

            // Divider
            Divider(color: Colors.grey.shade300, thickness: 1, height: 10),

            // Delete option
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.red.shade50,
                child: const Icon(Icons.delete, color: Colors.redAccent),
              ),
              title: const Text("Delete Message"),
              onTap: () {
                Navigator.pop(ctx);
                onDelete();
              },
            ),

            const SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}



  void _showEditDialog(BuildContext context) {
  final controller = TextEditingController(text: message);

  showDialog(
    context: context,
    builder: (ctx) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [
                Colors.pink.shade50,
                Colors.blue.shade50,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                " Edit Your Message ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 16),

              // TextField
              TextField(
                controller: controller,
                autofocus: true,
                maxLines: null,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Type something cute...",
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close, color: Colors.redAccent),
                    label: const Text("Cancel"),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 3,
                    ),
                    onPressed: () {
                      onEdit(controller.text.trim());
                      Navigator.pop(ctx);
                    },
                    icon: const Icon(Icons.favorite, size: 18),
                    label: const Text("Save"),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

   
}


