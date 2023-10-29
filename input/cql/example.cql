library example version '1.0.0'

using FHIR version '4.0.1'

include fhir.cqf.common.FHIRHelpers version '4.0.1'

codesystem "Observation Category Codes": 'http://terminology.hl7.org/CodeSystem/observation-category'

valueset "Encounter Inpatient": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.666.5.307'
valueset "Emergency Department Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.292'
valueset "Telephone Evaluation": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1082'
valueset "Telephone Management": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1053'

valueset "COVID-19 Screening Result": 'TBD'

code "Laboratory Observation Category": 'laboratory' from "Observation Category Codes"

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Inpatient, Emergency, or Telephone Evaluation or Management Encounter":
  (
    [Encounter: "Encounter Inpatient"]
      union [Encounter: "Emergency Department Visit"]
      union [Encounter: "Telephone Evaluation"]
      union [Encounter: "Telephone Management"]
  ) Encounter
    where Encounter.status = 'finished'
      and Encounter.period during "Measurement Period"

define "Initial Population":
  exists ("Inpatient, Emergency, or Telephone Evaluation or Management Encounter")

define "Denominator":
  true

define "COVID-19 Communicable Disease Screening":
  [Observation: "COVID-19 Screening Result"] Result
    where exists (Result.category C where C ~ "Laboratory Observation Category")
      and Result.status in { 'final', 'amended', 'corrected' }
      and Result.effective during "Measurement Period"

define "Numerator":
  exists ("COVID-19 Communicable Disease Screening")
