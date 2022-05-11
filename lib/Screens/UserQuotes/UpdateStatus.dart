class Status {
  bool _durum = false;
  String _selectedId = "";

  getDurum() {
    return _durum;
  }

  setDurum(bool durum) {
    _durum = durum;
  }

  getSelectedId() {
    return _selectedId;
  }

  setSelectedId(id) {
    _selectedId = id;
  }
}
