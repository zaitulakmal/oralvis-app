import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Form state for the screens that take input. Sample-data build: nothing is
/// saved anywhere yet; each form resets when its screen is left.

/// A profile form (yours, or a dependent's).
class ProfileForm {
  const ProfileForm({
    this.gender,
    this.ethnicity,
    this.state,
    this.city,
    this.relationship = 'Son',
  });
  final String? gender, ethnicity, state, city;
  final String relationship;

  ProfileForm copyWith({
    String? gender,
    String? ethnicity,
    String? state,
    String? city,
    bool clearCity = false,
    String? relationship,
  }) => ProfileForm(
    gender: gender ?? this.gender,
    ethnicity: ethnicity ?? this.ethnicity,
    state: state ?? this.state,
    city: clearCity ? null : (city ?? this.city),
    relationship: relationship ?? this.relationship,
  );
}

class ProfileFormNotifier extends Notifier<ProfileForm> {
  @override
  ProfileForm build() => const ProfileForm();

  void gender(String v) => state = state.copyWith(gender: v);
  void ethnicity(String v) => state = state.copyWith(ethnicity: v);
  void relationship(String v) => state = state.copyWith(relationship: v);

  /// Picking a different state clears the city, since it belonged to the old one.
  void pickState(String v) =>
      state = state.copyWith(state: v, clearCity: v != state.state);
  void city(String v) => state = state.copyWith(city: v);
}

final profileSetupProvider =
    NotifierProvider.autoDispose<ProfileFormNotifier, ProfileForm>(
      ProfileFormNotifier.new,
    );
final dependentFormProvider =
    NotifierProvider.autoDispose<ProfileFormNotifier, ProfileForm>(
      ProfileFormNotifier.new,
    );

/// A set of ticked options (medical conditions, symptoms).
class TickSet extends Notifier<Set<String>> {
  TickSet(this.initial);
  final Set<String> initial;
  @override
  Set<String> build() => initial;
  void toggle(String v) =>
      state = state.contains(v) ? ({...state}..remove(v)) : {...state, v};
}

final myConditionsProvider = NotifierProvider.autoDispose<TickSet, Set<String>>(
  () => TickSet({'Diabetes', 'Others'}),
);
final dependentConditionsProvider =
    NotifierProvider.autoDispose<TickSet, Set<String>>(() => TickSet({}));
final symptomsProvider = NotifierProvider.autoDispose<TickSet, Set<String>>(
  () => TickSet({'Toothache', 'Bleeding gums'}),
);

/// One choice from a row of pills.
class Choice extends Notifier<String> {
  Choice(this.initial);
  final String initial;
  @override
  String build() => initial;
  void set(String v) => state = v;
}

final durationProvider = NotifierProvider.autoDispose<Choice, String>(
  () => Choice('1–7 days'),
);
final libraryFilterProvider = NotifierProvider.autoDispose<Choice, String>(
  () => Choice('All'),
);

/// Pain level 1–5.
class PainLevel extends Notifier<int> {
  @override
  int build() => 3;
  void set(int v) => state = v.clamp(1, 5);
}

final painProvider = NotifierProvider.autoDispose<PainLevel, int>(
  PainLevel.new,
);
