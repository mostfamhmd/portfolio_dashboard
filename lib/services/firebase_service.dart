import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/personal_info.dart';
import '../models/skill.dart';
import '../models/project.dart';
import '../models/experience.dart';
import '../models/social_link.dart';

/// Service for writing portfolio data to Firebase Firestore
/// This service is used by the portfolio_dashboard app to persist data
class FirebaseService {
  static const String _collectionName = 'portfolio';
  static const String _documentId = 'data';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get reference to the portfolio document
  DocumentReference<Map<String, dynamic>> get _portfolioDoc =>
      _firestore.collection(_collectionName).doc(_documentId);

  // Personal Info
  Future<void> savePersonalInfo(PersonalInfo info) async {
    try {
      await _portfolioDoc.set({
        'personalInfo': info.toJson(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save personal info: $e');
    }
  }

  Future<PersonalInfo?> getPersonalInfo() async {
    try {
      final doc = await _portfolioDoc.get();
      if (!doc.exists) return null;
      final data = doc.data();
      if (data == null || !data.containsKey('personalInfo')) return null;
      return PersonalInfo.fromJson(
          Map<String, dynamic>.from(data['personalInfo']));
    } catch (e) {
      throw Exception('Failed to get personal info: $e');
    }
  }

  // Skills
  Future<void> saveSkills(List<Skill> skills) async {
    try {
      await _portfolioDoc.set({
        'skills': skills.map((s) => s.toJson()).toList(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save skills: $e');
    }
  }

  Future<List<Skill>> getSkills() async {
    try {
      final doc = await _portfolioDoc.get();
      if (!doc.exists) return [];
      final data = doc.data();
      if (data == null || !data.containsKey('skills')) return [];
      final List<dynamic> skillsList = data['skills'];
      return skillsList
          .map((json) => Skill.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } catch (e) {
      throw Exception('Failed to get skills: $e');
    }
  }

  // Projects
  Future<void> saveProjects(List<Project> projects) async {
    try {
      await _portfolioDoc.set({
        'projects': projects.map((p) => p.toJson()).toList(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save projects: $e');
    }
  }

  Future<List<Project>> getProjects() async {
    try {
      final doc = await _portfolioDoc.get();
      if (!doc.exists) return [];
      final data = doc.data();
      if (data == null || !data.containsKey('projects')) return [];
      final List<dynamic> projectsList = data['projects'];
      return projectsList
          .map((json) => Project.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } catch (e) {
      throw Exception('Failed to get projects: $e');
    }
  }

  // Experiences
  Future<void> saveExperiences(List<Experience> experiences) async {
    try {
      await _portfolioDoc.set({
        'experiences': experiences.map((e) => e.toJson()).toList(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save experiences: $e');
    }
  }

  Future<List<Experience>> getExperiences() async {
    try {
      final doc = await _portfolioDoc.get();
      if (!doc.exists) return [];
      final data = doc.data();
      if (data == null || !data.containsKey('experiences')) return [];
      final List<dynamic> experiencesList = data['experiences'];
      return experiencesList
          .map((json) => Experience.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } catch (e) {
      throw Exception('Failed to get experiences: $e');
    }
  }

  // Social Links
  Future<void> saveSocialLinks(List<SocialLink> links) async {
    try {
      await _portfolioDoc.set({
        'socialLinks': links.map((l) => l.toJson()).toList(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save social links: $e');
    }
  }

  Future<List<SocialLink>> getSocialLinks() async {
    try {
      final doc = await _portfolioDoc.get();
      if (!doc.exists) return [];
      final data = doc.data();
      if (data == null || !data.containsKey('socialLinks')) return [];
      final List<dynamic> linksList = data['socialLinks'];
      return linksList
          .map((json) => SocialLink.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } catch (e) {
      throw Exception('Failed to get social links: $e');
    }
  }

  // Batch save all data
  Future<void> saveAllData({
    PersonalInfo? personalInfo,
    List<Skill>? skills,
    List<Project>? projects,
    List<Experience>? experiences,
    List<SocialLink>? socialLinks,
  }) async {
    try {
      final Map<String, dynamic> data = {};

      if (personalInfo != null) {
        data['personalInfo'] = personalInfo.toJson();
      }
      if (skills != null) {
        data['skills'] = skills.map((s) => s.toJson()).toList();
      }
      if (projects != null) {
        data['projects'] = projects.map((p) => p.toJson()).toList();
      }
      if (experiences != null) {
        data['experiences'] = experiences.map((e) => e.toJson()).toList();
      }
      if (socialLinks != null) {
        data['socialLinks'] = socialLinks.map((l) => l.toJson()).toList();
      }

      if (data.isNotEmpty) {
        await _portfolioDoc.set(data, SetOptions(merge: true));
      }
    } catch (e) {
      throw Exception('Failed to save all data: $e');
    }
  }

  // Get all data
  Future<Map<String, dynamic>> getAllData() async {
    try {
      final doc = await _portfolioDoc.get();
      if (!doc.exists) return {};
      return doc.data() ?? {};
    } catch (e) {
      throw Exception('Failed to get all data: $e');
    }
  }

  // Clear all data
  Future<void> clearAllData() async {
    try {
      await _portfolioDoc.delete();
    } catch (e) {
      throw Exception('Failed to clear all data: $e');
    }
  }
}
