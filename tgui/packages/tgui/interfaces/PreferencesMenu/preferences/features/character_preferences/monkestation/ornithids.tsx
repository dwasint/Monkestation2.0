import {
  Feature,
  FeatureChoiced,
  FeatureColorInput,
  FeatureDropdownInput,
} from '../../base';

export const feature_arm_wings: FeatureChoiced = {
  name: 'Arm Wings',
  small_supplemental: false,
  component: FeatureDropdownInput,
};

export const feather_color: Feature<string> = {
  name: 'Feather Color',
  small_supplemental: false,
  description:
    "The color of your character's feathers. \
  (Armwings, Plumage).",
  component: FeatureColorInput,
};

export const feature_avian_tail: FeatureChoiced = {
  name: 'Tail',
  small_supplemental: false,
  component: FeatureDropdownInput,
};

export const feature_avian_ears: FeatureChoiced = {
  name: 'Plumage',
  small_supplemental: false,
  component: FeatureDropdownInput,
};

export const feature_satyr_horns: FeatureChoiced = {
  name: 'Satyr Horns',
  small_supplemental: false,
  component: FeatureDropdownInput,
};

export const feature_satyr_fluff: FeatureChoiced = {
  name: 'Satyr Fluff',
  small_supplemental: false,
  component: FeatureDropdownInput,
};

export const feature_satyr_tail: FeatureChoiced = {
  name: 'Tail',
  small_supplemental: false,
  component: FeatureDropdownInput,
};
