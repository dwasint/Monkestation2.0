import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';
import { Section, Button, Tabs, LabeledList } from '../components';

type ExtrapolatorData = {
  varients: [];
  diseases: DiseaseListData[];
};

type DiseaseListData = {
  name: string;
  ref: string;
  symptoms: SymptomListData[];
};

type SymptomListData = {
  name: string;
  ref: string;
};

export const Extrapolator = (props) => {
  const { act, data } = useBackend<ExtrapolatorData>();
  const { varients, diseases } = data;

  // State for selected disease and symptom
  // State for selected disease and symptom
  const [selectedDisease, setSelectedDisease] = useLocalState<string | ''>(
    'selectedDisease',
    '',
  );
  const [selectedSymptom, setSelectedSymptom] = useLocalState<string | ''>(
    'selectedSymptom',
    '',
  );

  // Handler for variant button click
  const handleVariantClick = (
    diseaseRef: string,
    symptomName: string,
    variantName: string,
  ) => {
    act('submitVariant', { diseaseRef, symptomName, variantName });
  };

  return (
    <Window>
      <Window.Content>
        <Section title="Diseases">
          <Tabs>
            {diseases.map((disease) => (
              <Tabs.Tab
                key={disease.ref}
                selected={selectedDisease === disease.ref}
                onClick={() => setSelectedDisease(disease.ref)}
              >
                {disease.name}
              </Tabs.Tab>
            ))}
          </Tabs>
        </Section>

        {selectedDisease && (
          <Section title="Symptoms">
            <Tabs>
              {diseases
                .find((disease) => disease.ref === selectedDisease)
                ?.symptoms.map((symptom) => (
                  <Tabs.Tab
                    key={symptom.ref}
                    selected={selectedSymptom === symptom.ref}
                    onClick={() => setSelectedSymptom(symptom.ref)}
                  >
                    {symptom.name}
                  </Tabs.Tab>
                ))}
            </Tabs>
          </Section>
        )}

        {selectedSymptom && (
          <Section title="varients">
            <LabeledList>
              {varients.map((variant, index) => (
                <LabeledList.Item key={index}>
                  <Button
                    onClick={() =>
                      act('add_varient', {
                        varient_name: variant,
                        disease_ref: selectedDisease,
                        symptom_ref: selectedSymptom,
                      })
                    }
                  >
                    {variant}
                  </Button>
                </LabeledList.Item>
              ))}
            </LabeledList>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
