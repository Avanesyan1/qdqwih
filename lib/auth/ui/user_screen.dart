

import 'package:diplom_main/auth/domain/auth_state/auth_cubit.dart';
import 'package:diplom_main/auth/ui/components/snack_bar.dart';
import 'package:diplom_main/widgets/app_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Личный кабинет"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).maybePop();
              context.read<AuthCubit>().logOut();
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          state.whenOrNull(
            authorized: (userEntity) {
              if (userEntity.userState?.hasData == true) {
                AppSnackBar.showSnackBarWithMessage(
                  context,
                  userEntity.userState?.data,
                );
              }

              if (userEntity.userState?.hasError == true) {
                AppSnackBar.showSnackBarWithError(
                  context,
                  "${userEntity.userState?.error}",
                );
              }
            },
          );
        },
        builder: (context, state) {
          final userEntity = state.whenOrNull(
            authorized: (userEntity) => userEntity,
          );

          if (userEntity?.userState?.connectionState ==
              ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      child: Text(
                          userEntity?.email.split("").first ?? "Отсутствует"),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        Text(userEntity?.displayName ?? "Без имени"),
                        Text(userEntity?.email ?? ""),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AppDialog(
                            val1: "Новый Пароль",
                            val2: "Повтор пороля",
                            onPressed: (v1, v2) {
                              context.read<AuthCubit>().passwordUpdate(
                                    newPassword: v1,
                                    repPassword: v2,
                                  );
                            },
                          ),
                        );
                      },
                      child: const Text("Обновить пароль"),
                    ),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AppDialog(
                            val1: "Имя пользователя",
                            val2: "Почта",
                            onPressed: (v1, v2) {
                              context.read<AuthCubit>().userUpdate(
                                    email: v2,
                                    username: v1,
                                  );
                            },
                          ),
                        );
                      },
                      child: const Text("Обновить данные"),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
