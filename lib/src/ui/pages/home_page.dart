import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vent/src/blocs/auth/auth_bloc.dart';
import 'package:vent/src/blocs/vents/vents_bloc.dart';
import 'package:vent/src/ui/pages/submit_vent_page.dart';
import 'package:vent/src/ui/widgets/vent_card_1.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(context) {
    return BlocProvider(
      create: (context) => VentsBloc()..add(VentsLoadRequested()),
      child: ListView(
        children: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthenticationSuccess)
                return RaisedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/submit_vent');
                  },
                  child: Text('Submit Vent'),
                );
              else
                return Text('signin to vent');
            },
          ),
          BlocConsumer<VentsBloc, VentsState>(
            listener: (context, state) {
              if (state.status == Status.LoadingFail)
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Failed loading vents'),
                  action: SnackBarAction(
                    onPressed: () {
                      context.read<VentsBloc>().add(VentsLoadRequested());
                    },
                    label: 'Retry',
                  ),
                ));
            },
            builder: (context, state) {
              print(state.status);
              print(state.error);
              if (state.status == Status.Loading)
                return Center(child: CircularProgressIndicator());
              else if (state.status == Status.Loaded)
                return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: state.vents.length,
                    itemBuilder: (context, index) {
                      return VentCard1(state.vents[index]);
                    });
              else
                return Container();
            },
          ),
        ],
      ),
    );
  }
}
