import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vults/core/constants/constant_string.dart';
import 'package:vults/model/notification_model.dart';
import 'package:vults/viewmodels/bloc/notification/notification_bloc.dart';
import 'package:vults/views/widgets/mobile/app_bar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(LoadNotificationsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: "Notifications",
        iconColor: ConstantString.darkBlue,
        fontColor: ConstantString.darkBlue,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        fontFamily: ConstantString.fontFredokaOne,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ConstantString.lightGrey, ConstantString.darkBlue],
          ),
        ),
        child: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NotificationsLoaded) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.notifications.length,
                itemBuilder: (context, index) {
                  final notification = state.notifications[index];
                  return _buildNotificationItem(
                    context,
                    notification: notification,
                  );
                },
              );
            } else if (state is NotificationError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('No notifications'));
          },
        ),
      ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context, {
    required NotificationModel notification,
  }) {
    bool isAlert = notification.type == NotificationType.security.toString();
    bool isUpdate = notification.type == NotificationType.system.toString();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: ConstantString.white,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color:
                isAlert
                    ? ConstantString.red.withOpacity(0.2)
                    : isUpdate
                    ? ConstantString.green.withOpacity(0.2)
                    : ConstantString.lightBlue.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isAlert
                ? Icons.warning
                : isUpdate
                ? Icons.update
                : Icons.notifications,
            color:
                isAlert
                    ? ConstantString.red
                    : isUpdate
                    ? ConstantString.green
                    : ConstantString.lightBlue,
          ),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: ConstantString.fontFredokaOne,
            color: ConstantString.darkGrey,
          ),
        ),
        subtitle: Text(
          notification.message,
          style: TextStyle(
            fontFamily: ConstantString.fontFredoka,
            color: ConstantString.grey,
          ),
        ),
        onTap: () {
          _showNotificationDetails(
            context,
            notification.title,
            notification.message,
            isAlert
                ? Icons.warning
                : (isUpdate ? Icons.update : Icons.notifications),
          );
          // Mark notification as read when opened
          if (!notification.isRead) {
            context.read<NotificationBloc>().add(
              MarkNotificationAsReadRequested(notification.id),
            );
          }
        },
      ),
    );
  }

  void _showNotificationDetails(
    BuildContext context,
    String title,
    String message,
    IconData icon,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(icon, size: 50, color: ConstantString.darkGrey),
                  SizedBox(height: 16),
                  Text(
                    message,
                    style: TextStyle(
                      fontFamily: ConstantString.fontFredoka,
                      fontSize: 16,
                      color: ConstantString.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Close",
                        style: TextStyle(
                          color: ConstantString.lightBlue,
                          fontFamily: ConstantString.fontFredokaOne,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
