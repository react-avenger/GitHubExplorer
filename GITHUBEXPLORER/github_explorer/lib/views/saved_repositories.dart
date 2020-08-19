import 'package:flutter/material.dart';
import 'package:github_explorer/listener/state_listener.dart';
import 'package:github_explorer/model/repository.dart';
import 'package:github_explorer/observer/repository_observer.dart';
import 'package:github_explorer/preference/preference_manager.dart';
import 'package:github_explorer/utilities.dart';

class SavedRepositories extends StatefulWidget {
  @override
  _SavedRepositoriesState createState() => _SavedRepositoriesState();
}

class _SavedRepositoriesState extends State<SavedRepositories>
    implements StateListener {
  List<Repository> _savedRepository = List();

  _SavedRepositoriesState() {
    var stateProvider = new StateProvider();
    stateProvider.subscribe(this);
  }

  @override
  onStateChanged(ObserverState state) {
    if (state == ObserverState.UN_SAVE_REPOSITORY) {
      if (mounted) {
        setState(() {
          PreferenceManager.setRepositoryData(Utilities.savedRepository);
          _savedRepository = Utilities.savedRepository;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    var _storedSavedRepository = PreferenceManager.getRepositoryData();
    if (_storedSavedRepository != null) {
      _savedRepository = _storedSavedRepository;
    } else {
      _savedRepository = Utilities.savedRepository;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
              child: Column(
            children: <Widget>[
              Text('Saved Repository',
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .apply(color: Colors.white)),
            ],
          )),
        ),
        body: displaySavedRepositories(context));
  }

  Widget displaySavedRepositories(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.white24,
      child: _bindSaveRepository(_savedRepository),
    );
  }

  Widget _bindSaveRepository(List<Repository> _repository) {
    if(_repository.length <= 0) {
      return Container(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                Icon(Icons.error_outline, size: 40.0),
                Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text('There is no saved repository found. Please save repository first.', style: TextStyle(fontSize: 18.0),),
                  )
                )
            ],
          )
      );
    } else {
      return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          itemCount: _savedRepository.length,
          itemBuilder: (BuildContext context, int index) {
            return savedRepositoryChild(_savedRepository[index]);
          });
    }
  }

  Widget savedRepositoryChild(Repository _repository) {
    return Card(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                            (_repository.name != null)
                                ? _repository.name
                                : 'No Title Available',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0)),
                        IconButton(
                          icon:
                          Icon(Icons.delete, color: Colors.redAccent, size: 20.0),
                          onPressed: () {
                            _unSaveRepository(_repository);
                          },
                        ),
                      ]),
                  Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                          (_repository.description != null)
                              ? _repository.description
                              : 'No Description found',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 15.0,
                              color: Colors.black54))),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Container(
                                child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.only(
                                              right: 8.0),
                                          child: Icon(Icons.language,
                                              color: Colors.grey,
                                              size: 18.0)),
                                      Text(
                                          (_repository.language != null)
                                              ? '${_repository.language}'
                                              : '',
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 13.0,
                                              color: Colors.black87)),
                                    ])))
                      ])
                ]))
    );
  }

  void _unSaveRepository(Repository repository) {
    Utilities.unSaveRepository(repository);

    if (mounted) {
      setState(() {
        _savedRepository = Utilities.savedRepository;
      });
    }
  }
}
