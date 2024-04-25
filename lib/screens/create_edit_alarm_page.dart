import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clock/cubit/app_cubit.dart';

class CreateEditScreen extends StatefulWidget {
  final AlarmSettings? alarmSettings;

  const CreateEditScreen({super.key, this.alarmSettings});

  @override
  State<CreateEditScreen> createState() => _ExampleAlarmEditScreenState();
}

class _ExampleAlarmEditScreenState extends State<CreateEditScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AppCubit>().initState(widget.alarmSettings);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context
                          .read<AppCubit>()
                          .saveAlarm(context, widget.alarmSettings?.id);
                    },
                    child: state.loading
                        ? const CircularProgressIndicator()
                        : const Text(
                            "Save",
                            style: TextStyle(
                                color: Colors.greenAccent, fontSize: 18),
                          ),
                  ),
                ],
              ),
              Text(
                context.read<AppCubit>().getDay(),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.blueAccent.withOpacity(0.8)),
              ),
              RawMaterialButton(
                onPressed: () => context.read<AppCubit>().pickTime(context),
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Text(
                    TimeOfDay.fromDateTime(state.selectedDateTime)
                        .format(context),
                    style:
                        Theme.of(context).textTheme.displayMedium!.copyWith(),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Loop alarm audio',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                  ),
                  Switch(
                    value: state.loopAudio,
                    onChanged: (value) =>
                        context.read<AppCubit>().loopSwitch(value),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Vibrate',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                  ),
                  Switch(
                    value: state.vibrate,
                    onChanged: (value) =>
                        context.read<AppCubit>().setVibrate(value),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sound',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                  ),
                  DropdownButton(
                    value: state.assetAudio,
                    underline: const SizedBox(),
                    isDense: true,
                    icon: const SizedBox(),
                    alignment: Alignment.centerRight,
                    borderRadius: BorderRadius.circular(12),
                    dropdownColor: Colors.grey,
                    items: context.read<AppCubit>().dropDownItemList,
                    onChanged: (value) =>
                        context.read<AppCubit>().setAssetAudio(value!),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Custom volume',
                      style:
                          Theme.of(context).textTheme.titleMedium ),
                  Switch(
                    value: state.volume != null,
                    onChanged: (value) =>
                        setState(() => state.volume = value ? 0.5 : null),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
                child: state.volume != null
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            state.volume! > 0.7
                                ? Icons.volume_up_rounded
                                : state.volume! > 0.1
                                    ? Icons.volume_down_rounded
                                    : Icons.volume_mute_rounded,
                            color: Colors.white,
                          ),
                          Expanded(
                            child: Slider(
                              value: state.volume!,
                              onChanged: (value) {
                                setState(() => state.volume = value);
                              },
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
              ),
              if (!state.creating)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.red,
                  ),
                  child: TextButton(
                    onPressed: () {
                      context
                          .read<AppCubit>()
                          .deleteAlarm(widget.alarmSettings!.id, context);
                      Navigator.pop(context);
                    },
                    child: const Text('Delete Alarm',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
              const SizedBox(),
            ],
          ),
        );
      },
    );
  }
}
