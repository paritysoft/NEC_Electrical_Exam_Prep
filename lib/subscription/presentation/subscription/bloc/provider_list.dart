import 'package:electrician/subscription/presentation/subscription/bloc/subscription_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';
import '../../../dependencyinjection/injection_container.dart';


List<SingleChildWidget> providers = [
  BlocProvider<SubscriptionBloc>(create: (context) => serviceLocator<SubscriptionBloc>()),
];

