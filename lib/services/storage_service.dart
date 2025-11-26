import '../models/personal_info.dart';
import '../models/skill.dart';
import '../models/project.dart';
import '../models/experience.dart';
import '../models/social_link.dart';
import 'firebase_service.dart';

enum SyncStatus { idle, syncing, synced, error }

class StorageService {
  final FirebaseService _firebaseService = FirebaseService();

  // Sync state tracking
  SyncStatus _syncStatus = SyncStatus.idle;
  String? _lastError;
  Function(SyncStatus, String?)? _onSyncStatusChanged;

  SyncStatus get syncStatus => _syncStatus;
  String? get lastError => _lastError;

  void setOnSyncStatusChanged(Function(SyncStatus, String?) callback) {
    _onSyncStatusChanged = callback;
  }

  void _updateSyncStatus(SyncStatus status, [String? error]) {
    _syncStatus = status;
    _lastError = error;
    _onSyncStatusChanged?.call(status, error);
  }

  // Personal Info
  Future<PersonalInfo> getPersonalInfo() async {
    final info = await _firebaseService.getPersonalInfo();
    return info ?? PersonalInfo.empty;
  }

  Future<void> savePersonalInfo(PersonalInfo info) async {
    _updateSyncStatus(SyncStatus.syncing);
    try {
      await _firebaseService.savePersonalInfo(info);
      _updateSyncStatus(SyncStatus.synced);
    } catch (e) {
      final errorMsg = 'Failed to sync personal info: ${e.toString()}';
      _updateSyncStatus(SyncStatus.error, errorMsg);
      rethrow;
    }
  }

  // Skills
  Future<List<Skill>> getSkills() async {
    return await _firebaseService.getSkills();
  }

  Future<void> saveSkills(List<Skill> skills) async {
    _updateSyncStatus(SyncStatus.syncing);
    try {
      await _firebaseService.saveSkills(skills);
      _updateSyncStatus(SyncStatus.synced);
    } catch (e) {
      final errorMsg = 'Failed to sync skills: ${e.toString()}';
      _updateSyncStatus(SyncStatus.error, errorMsg);
      rethrow;
    }
  }

  Future<void> addSkill(Skill skill) async {
    final skills = await getSkills();
    skills.add(skill);
    await saveSkills(skills);
  }

  Future<void> updateSkill(Skill skill) async {
    final skills = await getSkills();
    final index = skills.indexWhere((s) => s.id == skill.id);
    if (index != -1) {
      skills[index] = skill;
      await saveSkills(skills);
    }
  }

  Future<void> deleteSkill(String id) async {
    final skills = await getSkills();
    skills.removeWhere((s) => s.id == id);
    await saveSkills(skills);
  }

  // Projects
  Future<List<Project>> getProjects() async {
    return await _firebaseService.getProjects();
  }

  Future<void> saveProjects(List<Project> projects) async {
    _updateSyncStatus(SyncStatus.syncing);
    try {
      await _firebaseService.saveProjects(projects);
      _updateSyncStatus(SyncStatus.synced);
    } catch (e) {
      final errorMsg = 'Failed to sync projects: ${e.toString()}';
      _updateSyncStatus(SyncStatus.error, errorMsg);
      rethrow;
    }
  }

  Future<void> addProject(Project project) async {
    final projects = await getProjects();
    projects.add(project);
    await saveProjects(projects);
  }

  Future<void> updateProject(Project project) async {
    final projects = await getProjects();
    final index = projects.indexWhere((p) => p.id == project.id);
    if (index != -1) {
      projects[index] = project;
      await saveProjects(projects);
    }
  }

  Future<void> deleteProject(String id) async {
    final projects = await getProjects();
    projects.removeWhere((p) => p.id == id);
    await saveProjects(projects);
  }

  // Experiences
  Future<List<Experience>> getExperiences() async {
    return await _firebaseService.getExperiences();
  }

  Future<void> saveExperiences(List<Experience> experiences) async {
    _updateSyncStatus(SyncStatus.syncing);
    try {
      await _firebaseService.saveExperiences(experiences);
      _updateSyncStatus(SyncStatus.synced);
    } catch (e) {
      final errorMsg = 'Failed to sync experiences: ${e.toString()}';
      _updateSyncStatus(SyncStatus.error, errorMsg);
      rethrow;
    }
  }

  Future<void> addExperience(Experience experience) async {
    final experiences = await getExperiences();
    experiences.add(experience);
    await saveExperiences(experiences);
  }

  Future<void> updateExperience(Experience experience) async {
    final experiences = await getExperiences();
    final index = experiences.indexWhere((e) => e.id == experience.id);
    if (index != -1) {
      experiences[index] = experience;
      await saveExperiences(experiences);
    }
  }

  Future<void> deleteExperience(String id) async {
    final experiences = await getExperiences();
    experiences.removeWhere((e) => e.id == id);
    await saveExperiences(experiences);
  }

  // Social Links
  Future<List<SocialLink>> getSocialLinks() async {
    return await _firebaseService.getSocialLinks();
  }

  Future<void> saveSocialLinks(List<SocialLink> links) async {
    _updateSyncStatus(SyncStatus.syncing);
    try {
      await _firebaseService.saveSocialLinks(links);
      _updateSyncStatus(SyncStatus.synced);
    } catch (e) {
      final errorMsg = 'Failed to sync social links: ${e.toString()}';
      _updateSyncStatus(SyncStatus.error, errorMsg);
      rethrow;
    }
  }

  Future<void> addSocialLink(SocialLink link) async {
    final links = await getSocialLinks();
    links.add(link);
    await saveSocialLinks(links);
  }

  Future<void> updateSocialLink(SocialLink link) async {
    final links = await getSocialLinks();
    final index = links.indexWhere((l) => l.id == link.id);
    if (index != -1) {
      links[index] = link;
      await saveSocialLinks(links);
    }
  }

  Future<void> deleteSocialLink(String id) async {
    final links = await getSocialLinks();
    links.removeWhere((l) => l.id == id);
    await saveSocialLinks(links);
  }

  // Export data
  Future<Map<String, dynamic>> exportData() async {
    final personalInfo = await getPersonalInfo();
    final skills = await getSkills();
    final projects = await getProjects();
    final experiences = await getExperiences();
    final socialLinks = await getSocialLinks();

    return {
      'personalInfo': personalInfo.toJson(),
      'skills': skills.map((s) => s.toJson()).toList(),
      'projects': projects.map((p) => p.toJson()).toList(),
      'experiences': experiences.map((e) => e.toJson()).toList(),
      'socialLinks': socialLinks.map((l) => l.toJson()).toList(),
    };
  }
}
