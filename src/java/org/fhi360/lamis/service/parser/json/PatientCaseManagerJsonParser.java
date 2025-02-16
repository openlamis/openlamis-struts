/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.fhi360.lamis.service.parser.json;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import javax.xml.bind.JAXBException;
import org.fhi360.lamis.dao.hibernate.PatientCaseManagerDAO;
import org.fhi360.lamis.dao.jdbc.PatientCaseManagerJDBC;
import org.fhi360.lamis.dao.jdbc.PatientJDBC;
import org.fhi360.lamis.model.Patient;
import org.fhi360.lamis.model.Patientcasemanager;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author Idris
 */
public class PatientCaseManagerJsonParser {
    
    public void parserJson(String table, String content) {
        try {

            JSONObject jsonObj = new JSONObject(content);
            JSONArray jsonArray = jsonObj.optJSONArray(table);
            for (int i = 0; i < jsonArray.length(); i++) {
                JSONObject record = jsonArray.optJSONObject(i);
                Patientcasemanager patientcasemanager = getObject(record.toString());
                DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
               
                
                   long patientId = new PatientJDBC().getPatientId(patientcasemanager.getFacilityId(), patientcasemanager.getPatient().getHospitalNum());
                Patient patient = new Patient();
                patient.setPatientId(patientId);
                
                patientcasemanager.setPatient(patient);
                long patientcasemanagerId = new PatientCaseManagerJDBC().getPatientcaseManagerId(patientcasemanager.getFacilityId(),
                         patientId, dateFormat.format(patientcasemanager.getDateAssigned()));
                if (patientcasemanagerId == 0L) {
                    PatientCaseManagerDAO.save(patientcasemanager);
                } else {
                    patientcasemanager.setPatientcasemanagerId(patientcasemanagerId);
                   PatientCaseManagerDAO.update(patientcasemanager);
                }

            }
        } catch (IOException | JAXBException | JSONException exception) {
            throw new RuntimeException(exception);
        }
    }

    private static Patientcasemanager getObject(String content) throws JAXBException, JsonParseException, JsonMappingException, IOException {
        Patientcasemanager patientcasemanager = new Patientcasemanager();
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
            objectMapper.setDateFormat(new SimpleDateFormat("yyyy-MM-dd"));
            patientcasemanager = objectMapper.readValue(content, Patientcasemanager.class);
        } catch (IOException exception) {
            throw new RuntimeException(exception);
        }
        return patientcasemanager;
    }
}
