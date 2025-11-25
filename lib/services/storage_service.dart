import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/personal_info.dart';
import '../models/skill.dart';
import '../models/project.dart';
import '../models/experience.dart';
import '../models/social_link.dart';

class StorageService {
  static const String _boxName = 'portfolio_data';
  static const String _personalInfoKey = 'personal_info';
  static const String _skillsKey = 'skills';
  static const String _projectsKey = 'projects';
  static const String _experiencesKey = 'experiences';
  static const String _socialLinksKey = 'social_links';

  late Box _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);

    // Seed default data if empty
    if (!_box.containsKey(_personalInfoKey)) {
      await _seedDefaultData();
    }
  }

  // Personal Info
  PersonalInfo getPersonalInfo() {
    final data = _box.get(_personalInfoKey);
    if (data == null) return PersonalInfo.empty;
    return PersonalInfo.fromJson(Map<String, dynamic>.from(jsonDecode(data)));
  }

  Future<void> savePersonalInfo(PersonalInfo info) async {
    await _box.put(_personalInfoKey, jsonEncode(info.toJson()));
  }

  // Skills
  List<Skill> getSkills() {
    final data = _box.get(_skillsKey);
    if (data == null) return [];
    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList
        .map((json) => Skill.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  Future<void> saveSkills(List<Skill> skills) async {
    final jsonList = skills.map((skill) => skill.toJson()).toList();
    await _box.put(_skillsKey, jsonEncode(jsonList));
  }

  Future<void> addSkill(Skill skill) async {
    final skills = getSkills();
    skills.add(skill);
    await saveSkills(skills);
  }

  Future<void> updateSkill(Skill skill) async {
    final skills = getSkills();
    final index = skills.indexWhere((s) => s.id == skill.id);
    if (index != -1) {
      skills[index] = skill;
      await saveSkills(skills);
    }
  }

  Future<void> deleteSkill(String id) async {
    final skills = getSkills();
    skills.removeWhere((s) => s.id == id);
    await saveSkills(skills);
  }

  // Projects
  List<Project> getProjects() {
    final data = _box.get(_projectsKey);
    if (data == null) return [];
    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList
        .map((json) => Project.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  Future<void> saveProjects(List<Project> projects) async {
    final jsonList = projects.map((project) => project.toJson()).toList();
    await _box.put(_projectsKey, jsonEncode(jsonList));
  }

  Future<void> addProject(Project project) async {
    final projects = getProjects();
    projects.add(project);
    await saveProjects(projects);
  }

  Future<void> updateProject(Project project) async {
    final projects = getProjects();
    final index = projects.indexWhere((p) => p.id == project.id);
    if (index != -1) {
      projects[index] = project;
      await saveProjects(projects);
    }
  }

  Future<void> deleteProject(String id) async {
    final projects = getProjects();
    projects.removeWhere((p) => p.id == id);
    await saveProjects(projects);
  }

  // Experiences
  List<Experience> getExperiences() {
    final data = _box.get(_experiencesKey);
    if (data == null) return [];
    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList
        .map((json) => Experience.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  Future<void> saveExperiences(List<Experience> experiences) async {
    final jsonList = experiences.map((exp) => exp.toJson()).toList();
    await _box.put(_experiencesKey, jsonEncode(jsonList));
  }

  Future<void> addExperience(Experience experience) async {
    final experiences = getExperiences();
    experiences.add(experience);
    await saveExperiences(experiences);
  }

  Future<void> updateExperience(Experience experience) async {
    final experiences = getExperiences();
    final index = experiences.indexWhere((e) => e.id == experience.id);
    if (index != -1) {
      experiences[index] = experience;
      await saveExperiences(experiences);
    }
  }

  Future<void> deleteExperience(String id) async {
    final experiences = getExperiences();
    experiences.removeWhere((e) => e.id == id);
    await saveExperiences(experiences);
  }

  // Social Links
  List<SocialLink> getSocialLinks() {
    final data = _box.get(_socialLinksKey);
    if (data == null) return [];
    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList
        .map((json) => SocialLink.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  Future<void> saveSocialLinks(List<SocialLink> links) async {
    final jsonList = links.map((link) => link.toJson()).toList();
    await _box.put(_socialLinksKey, jsonEncode(jsonList));
  }

  Future<void> addSocialLink(SocialLink link) async {
    final links = getSocialLinks();
    links.add(link);
    await saveSocialLinks(links);
  }

  Future<void> updateSocialLink(SocialLink link) async {
    final links = getSocialLinks();
    final index = links.indexWhere((l) => l.id == link.id);
    if (index != -1) {
      links[index] = link;
      await saveSocialLinks(links);
    }
  }

  Future<void> deleteSocialLink(String id) async {
    final links = getSocialLinks();
    links.removeWhere((l) => l.id == id);
    await saveSocialLinks(links);
  }

  // Clear all data
  Future<void> clearAll() async {
    await _box.clear();
    await _seedDefaultData();
  }

  // Export data
  Map<String, dynamic> exportData() {
    return {
      'personalInfo': getPersonalInfo().toJson(),
      'skills': getSkills().map((s) => s.toJson()).toList(),
      'projects': getProjects().map((p) => p.toJson()).toList(),
      'experiences': getExperiences().map((e) => e.toJson()).toList(),
      'socialLinks': getSocialLinks().map((l) => l.toJson()).toList(),
    };
  }

  // Seed default data
  Future<void> _seedDefaultData() async {
    // Default personal info
    final defaultInfo = PersonalInfo(
      name: 'Your Name',
      title: 'Flutter Developer',
      bio:
          'Add your bio here. Talk about your passion, experience, and what makes you unique.',
      photoUrl: 'https://via.placeholder.com/300',
      email: 'your.email@example.com',
      phone: '+1234567890',
      location: 'Your City, Country',
    );
    await savePersonalInfo(defaultInfo);

    // Default skills
    final defaultSkills = [
      Skill(
        id: '1',
        name: 'Flutter',
        proficiency: 90,
        category: 'Mobile Development',
      ),
      Skill(
        id: '2',
        name: 'Dart',
        proficiency: 85,
        category: 'Programming Languages',
      ),
      Skill(id: '3', name: 'Firebase', proficiency: 80, category: 'Backend'),
    ];
    await saveSkills(defaultSkills);

    // Default projects
    final defaultProjects = [
      Project(
        id: '1',
        title: 'Sample Project',
        description:
            'Add project description here. Explain what you built, the problem it solves, and your role.',
        imageUrl: 'https://via.placeholder.com/600x400',
        technologies: ['Flutter', 'Firebase', 'Dart'],
        projectUrl: '',
        githubUrl: '',
        isFeatured: true,
      ),
    ];
    await saveProjects(defaultProjects);

    // Default social links
    final defaultLinks = [
      SocialLink(
        id: '1',
        platform: 'GitHub',
        url: 'https://github.com/yourusername',
        iconName: 'github',
      ),
      SocialLink(
        id: '2',
        platform: 'LinkedIn',
        url: 'https://linkedin.com/in/yourusername',
        iconName: 'linkedin',
      ),
    ];
    await saveSocialLinks(defaultLinks);
  }
}
