import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:github_explorer/listener/state_listener.dart';
import 'package:github_explorer/model/repository.dart';
import 'package:github_explorer/observer/repository_observer.dart';
import 'package:github_explorer/preference/preference_manager.dart';
import 'package:github_explorer/server/server_request.dart';
import 'package:github_explorer/utilities.dart';
import 'package:github_explorer/views/saved_repositories.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> implements StateListener {
  String _serverError;
  bool _isLoading = false;
  int _savedRepositoryCount = 0;

  List<Repository> _repositories = List();

  _DashboardState() {
    var stateProvider = new StateProvider();
    stateProvider.subscribe(this);
  }

  @override
  void initState() {
    super.initState();
    setupPreferenceManager();
    getRepositories();
  }

  @override
  onStateChanged(ObserverState state) {
    if (state == ObserverState.SAVE_REPOSITORY) {
      if (mounted) {
        setState(() {
          _savedRepositoryCount = Utilities.savedRepository.length;
          PreferenceManager.setRepositoryData(Utilities.savedRepository);

        });
      }
    } else if (state == ObserverState.UN_SAVE_REPOSITORY) {
      if (mounted) {
        setState(() {
          _savedRepositoryCount = Utilities.savedRepository.length;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
            child: Column(
          children: <Widget>[
            Text('Repositories',
                style: Theme.of(context)
                    .textTheme
                    .title
                    .apply(color: Colors.white)),
          ],
        )),
        actions: <Widget>[
          Badge(
            position: BadgePosition.topRight(top: 4, right: 2),
            badgeColor: Colors.white,
            badgeContent: Text('${_savedRepositoryCount ?? "0"}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0)),
            child: IconButton(
                icon: Icon(Icons.bookmark, size: 24.0),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SavedRepositories()),
                  );
                }),
          ),
        ],
      ),
      body: displayRepositories(context),
    );
  }

  Widget displayRepositories(BuildContext context) {
    if (_isLoading) {
      return Container(
          alignment: Alignment.center, child: Icon(Icons.timelapse));
    } else if (_serverError != null) {
      return Container(
          alignment: Alignment.center,
          child:
              Text(_serverError, style: Theme.of(context).textTheme.headline));
    } else {
      return Container(
        padding: EdgeInsets.all(8.0),
        color: Colors.white24,
        child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            itemCount: _repositories.length,
            itemBuilder: (BuildContext context, int index) {
              return repositoryChild(_repositories[index]);
            }),
      );
    }
  }

  Widget repositoryChild(Repository _repository) {
    bool isSaved = false;
    for (var i = 0; i < Utilities.savedRepository.length; i++) {
      if (_repository.id == Utilities.savedRepository[i].id) {
        isSaved = true;
      }
    }

    return Card(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
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
                                fontWeight: FontWeight.bold, fontSize: 18.0)),
                        IconButton(
                          icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border, color: Colors.grey, size: 20.0),
                          onPressed: () {
                            Utilities.saveRepository(_repository);
                            setState(() {
                              isSaved = !isSaved;
                            });
                          },
                        ),
                      ]),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 8.0, 0, 16.0),
                      child: Text(
                          (_repository.description != null)
                              ? _repository.description
                              : 'No Description found',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 15.0,
                              color: Colors.black54))),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Icon(Icons.access_time,
                                      color: Colors.grey, size: 18.0)),
                              Text(
                                  (_repository.repoCreatedDate != null)
                                      ? '${Utilities.getRepositoryCreatedDate(_repository.repoCreatedDate)}'
                                      : '',
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 13.0,
                                      color: Colors.black87))
                            ])),
                        Container(
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Icon(Icons.star_border,
                                      color: Colors.grey, size: 18.0)),
                              Text(
                                  (_repository.ratingStarsCount != null)
                                      ? '${_repository.ratingStarsCount}'
                                      : '0',
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 13.0,
                                      color: Colors.black87))
                            ])),
                        Container(
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Icon(Icons.language,
                                      color: Colors.grey, size: 18.0)),
                              Text(
                                  (_repository.language != null)
                                      ? '${_repository.language}'
                                      : '',
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 13.0,
                                      color: Colors.black87)),
                            ]))
                      ])
                ])));
  }

  void getRepositories() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    final Stream<Repository> streamRepository = await ServerRequest.getRepositories();
    streamRepository.listen((Repository repository) {
      if (mounted) {
        setState(() {
          if (repository != null) {
            _repositories.add(repository);
          } else {
            _serverError = 'Something went wrong while fetching repositories.';
          }
          _isLoading = false;
        });
      }
    });
  }

  void setupPreferenceManager() async {
    // ignore: unused_local_variable
    var instance = await PreferenceManager.getInstance();
    var _storedSavedRepository = PreferenceManager.getRepositoryData();
    if (_storedSavedRepository != null) {
      _savedRepositoryCount = _storedSavedRepository.length;
      Utilities.savedRepository = _storedSavedRepository;
    } else {
      _savedRepositoryCount = 0;
    }
  }
}
