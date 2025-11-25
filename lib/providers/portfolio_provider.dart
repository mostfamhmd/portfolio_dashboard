import 'package:flutter/material.dart';
import '../models/personal_info.dart';
import '../models/skill.dart';
import '../models/project.dart';
import '../models/experience.dart';
import '../models/social_link.dart';
import '../services/storage_service.dart';

class PortfolioProvider with ChangeNotifier {
  final StorageService _storage;

  PortfolioProvider(this._storage) {
    _loadData();
  }

  // State
  PersonalInfo _personalInfo = PersonalInfo.empty;
  List<Skill> _skills = [];
  List<Project> _projects = [];
  List<Experience> _experiences = [];
  List<SocialLink> _socialLinks = [];
  bool _isLoading = false;

  // Getters
  PersonalInfo get personalInfo => _personalInfo;
  List<Skill> get skills => List.unmodifiable(_skills);
  List<Project> get projects => List.unmodifiable(_projects);
  List<Experience> get experiences => List.unmodifiable(_experiences);
  List<SocialLink> get socialLinks => List.unmodifiable(_socialLinks);
  bool get isLoading => _isLoading;

  // Categorized skills
  Map<String, List<Skill>> get skillsByCategory {
    final Map<String, List<Skill>> categorized = {};
    for (var skill in _skills) {
      if (!categorized.containsKey(skill.category)) {
        categorized[skill.category] = [];
      }
      categorized[skill.category]!.add(skill);
    }
    return categorized;
  }

  // Featured projects
  List<Project> get featuredProjects =>
      _projects.where((p) => p.isFeatured).toList();

  // Work experiences
  List<Experience> get workExperiences =>
      _experiences.where((e) => e.type == 'work').toList();

  // Education experiences
  List<Experience> get educationExperiences =>
      _experiences.where((e) => e.type == 'education').toList();

  // Load all data
  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();

    _personalInfo = _storage.getPersonalInfo();
    _skills = _storage.getSkills();
    _projects = _storage.getProjects();
    _experiences = _storage.getExperiences();
    _socialLinks = _storage.getSocialLinks();

    _isLoading = false;
    notifyListeners();
  }

  // Personal Info Methods
  Future<void> updatePersonalInfo(PersonalInfo info) async {
    await _storage.savePersonalInfo(info);
    _personalInfo = info;
    notifyListeners();
  }

  // Skill Methods
  Future<void> addSkill(Skill skill) async {
    await _storage.addSkill(skill);
    _skills = _storage.getSkills();
    notifyListeners();
  }

  Future<void> updateSkill(Skill skill) async {
    await _storage.updateSkill(skill);
    _skills = _storage.getSkills();
    notifyListeners();
  }

  Future<void> deleteSkill(String id) async {
    await _storage.deleteSkill(id);
    _skills = _storage.getSkills();
    notifyListeners();
  }

  // Project Methods
  Future<void> addProject(Project project) async {
    await _storage.addProject(project);
    _projects = _storage.getProjects();
    notifyListeners();
  }

  Future<void> updateProject(Project project) async {
    await _storage.updateProject(project);
    _projects = _storage.getProjects();
    notifyListeners();
  }

  Future<void> deleteProject(String id) async {
    await _storage.deleteProject(id);
    _projects = _storage.getProjects();
    notifyListeners();
  }

  // Experience Methods
  Future<void> addExperience(Experience experience) async {
    await _storage.addExperience(experience);
    _experiences = _storage.getExperiences();
    notifyListeners();
  }

  Future<void> updateExperience(Experience experience) async {
    await _storage.updateExperience(experience);
    _experiences = _storage.getExperiences();
    notifyListeners();
  }

  Future<void> deleteExperience(String id) async {
    await _storage.deleteExperience(id);
    _experiences = _storage.getExperiences();
    notifyListeners();
  }

  // Social Link Methods
  Future<void> addSocialLink(SocialLink link) async {
    await _storage.addSocialLink(link);
    _socialLinks = _storage.getSocialLinks();
    notifyListeners();
  }

  Future<void> updateSocialLink(SocialLink link) async {
    await _storage.updateSocialLink(link);
    _socialLinks = _storage.getSocialLinks();
    notifyListeners();
  }

  Future<void> deleteSocialLink(String id) async {
    await _storage.deleteSocialLink(id);
    _socialLinks = _storage.getSocialLinks();
    notifyListeners();
  }

  // Refresh data
  Future<void> refresh() async {
    await _loadData();
  }
}
