import 'package:get/get.dart';

class StaffMember {
  final String id;
  final String name;
  final String email;
  final String role;
  RxBool active;

  StaffMember({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required bool active,
  }) : active = active.obs;
}

class AdminSettingsController extends GetxController {
  var currentTab = 0.obs; // 0 = Profil | 1 = Personnel

  // Profil admin
  var fullName = 'Jean Dupont'.obs;
  var email = 'jean.dupont@email.com'.obs;
  var phone = '+33 6 12 34 56 78'.obs;

  // Personnel
  var staff = <StaffMember>[
    StaffMember(
      id: '1',
      name: 'Marie Martin',
      email: 'marie@bar.com',
      role: 'Serveur',
      active: true,
    ),
    StaffMember(
      id: '2',
      name: 'Pierre Durand',
      email: 'pierre@bar.com',
      role: 'Barman',
      active: true,
    ),
    StaffMember(
      id: '3',
      name: 'Sophie Leroy',
      email: 'sophie@bar.com',
      role: 'Serveur',
      active: false,
    ),
  ].obs;

  void toggleStaffStatus(StaffMember member) {
    member.active.toggle();
  }

  void removeStaff(String id) {
    staff.removeWhere((e) => e.id == id);
  }

  void addStaff(StaffMember member) {
    staff.add(member);
  }
}
