/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.fhi360.lamis.controller.chart.treatment;

import static com.opensymphony.xwork2.Action.ERROR;
import static com.opensymphony.xwork2.Action.SUCCESS;
import com.opensymphony.xwork2.ActionSupport;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.apache.struts2.ServletActionContext;
import org.fhi360.lamis.service.chart.IndicatorCompareTrendChartService;
import org.fhi360.lamis.utility.ChartUtil;
import org.fhi360.lamis.utility.DateUtil;

/**
 *
 * @author user10
 */
public class ViralLoadTestVsSuppressedChartAction extends ActionSupport {
    
  private static final String DATA_ELEMENT_IDS = "18,19";   

   private long ipId;
   private long stateId ;
   private long lgaId;
   private long facilityId;
   
   private List<String> categories;
   private List<Map<String, Object>> series;
   private String title;
   private String subtitle;
   private String titleForYAxis;
   private  List<Integer> data1 = new ArrayList<Integer>();
   private  List<Integer> data2 = new ArrayList<Integer>();
   private  List<Double> data3 = new ArrayList<Double>();

    private IndicatorCompareTrendChartService chartService;
    private ChartUtil chartUtil = new ChartUtil();
    private  HttpServletRequest request = ServletActionContext.getRequest();
    
    private Date reportingDateBegin;
    private Date reportingDateEnd;
    
    public String chartData() {
        chartUtil = new ChartUtil();
        request = ServletActionContext.getRequest();

        chartService = new IndicatorCompareTrendChartService();

        categories = new ArrayList<String>();
        series = new ArrayList<Map<String, Object>>();

        ipId = (!request.getParameter("ipId").isEmpty()) ? Long.parseLong(request.getParameter("ipId")) : 1;
        stateId = (!request.getParameter("stateId").isEmpty()) ? Long.parseLong(request.getParameter("stateId")) : 0;
        lgaId = (!request.getParameter("lgaId").isEmpty()) ? Long.parseLong(request.getParameter("lgaId")) : 0;
        facilityId = (!request.getParameter("facilityId").isEmpty()) ? Long.parseLong(request.getParameter("facilityId")) : 0;

        try {
            Date today = new Date();

            reportingDateBegin = (!request.getParameter("reportingDateBegin").isEmpty()) ? DateUtil.parseStringToDate(request.getParameter("reportingDateBegin"), "yyyy-MM-dd") :today;
            reportingDateEnd = (!request.getParameter("reportingDateEnd").isEmpty()) ? DateUtil.parseStringToDate(request.getParameter("reportingDateEnd"), "yyyy-MM-dd") : today;

        chartByDay();
            
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("type", "column");
        map.put("name", "Viral Load Test Received");
        map.put("data", data1);
        series.add(map);

        map = new HashMap<String, Object>();
        map.put("type", "column");
        map.put("name", "Viral Load Result <1000c/ml");
        map.put("data", data2);
        series.add(map);

        map = new HashMap<String, Object>();
        map.put("type", "spline");
        map.put("name", "VL Suppression Rate");
        map.put("data", data3);
        series.add(map);
        
        String periodStart = DateUtil.parseDateToString(reportingDateBegin, "dd MMMMM, yyyy");
        String periodEnd = DateUtil.parseDateToString(reportingDateEnd, "dd MMMMM, yyyy");
        title = "Viral Load Test Vs Virally Suppressed";
        subtitle = periodStart + " to " + periodEnd;
        setTitle(title);
        setSubtitle(subtitle);
        setCategories(categories);
        setTitleForYAxis("Number");
        setSeries(series);

        } catch (Exception ex) {
            ex.printStackTrace();
             return ERROR;
        }       
        return SUCCESS;
    }
    
    private void chartByDay() {

        try {
            int value1;
            int value2;
            double value3;

            int daysBetween = DateUtil.daysBetween(reportingDateBegin, reportingDateEnd);
            if(daysBetween > 7) {
                chartByMonth();
            } 
            else {
                    for (int i = 0; i <= daysBetween; i++) {
                    Date startDate = DateUtil.addDay(reportingDateBegin, i);
                    Date endDate = startDate;

                    Map<String, Object> period = chartUtil.getDayPeriod(reportingDateBegin, i);
                    String periodLabel = (String) period.get("periodLabel");

                    Map values = chartService.chartData(ipId, stateId, lgaId, facilityId, DATA_ELEMENT_IDS, startDate, endDate);
                    if(values != null && !values.isEmpty()) {
                            value1 = values.get("value1") != null? (Integer) values.get("value1") : 0;
                            value2 = values.get("value2") != null? (Integer) values.get("value2") : 0;
                            value3 =  chartUtil.getPercentage(value2, value1);
                    } else{
                        value1 = 0;
                        value2 = 0;
                        value3 = 0;  
                    }   
                    data1.add(value1);
                    data2.add(value2);
                    data3.add(value3);

                    categories.add(periodLabel);
                }

            }
                
        } catch (Exception ex) {
            ex.printStackTrace();
        }

    }
    
    
    private void chartByMonth() {
        try {
            int value1;
            int value2;
            double value3;
            
            int monthsBetween = DateUtil.monthsBetweenIgnoreDays(reportingDateBegin, reportingDateEnd);
            for (int i = 0; i <= monthsBetween; i++) {
                Map<String, Object> period = chartUtil.getPeriod(reportingDateBegin, i);
                int year = (Integer) period.get("year");
                int month = (Integer) period.get("month");
                String periodLabel = (String) period.get("periodLabel");
                
                Date startDate = DateUtil.getFirstDateOfMonth(year, month);
                Date endDate = DateUtil.getLastDateOfMonth(year, month);

                Map values = chartService.chartData(ipId, stateId, lgaId, facilityId, DATA_ELEMENT_IDS, startDate, endDate);
                if(values != null && !values.isEmpty()) {
                            value1 = values.get("value1") != null? (Integer) values.get("value1") : 0;
                            value2 = values.get("value2") != null? (Integer) values.get("value2") : 0;
                            value3 =  chartUtil.getPercentage(value2, value1);
                } else{
                    value1 = 0;
                    value2 = 0;
                    value3 = 0;  
                }   
                data1.add(value1);
                data2.add(value2);
                data3.add(value3);
                
                categories.add(periodLabel);
            }
        } catch (Exception ex) {
         ex.printStackTrace();
        }

    }

    /**
     * @return the categories
     */
    public List<String> getCategories() {
        return categories;
    }

    /**
     * @param categories the categories to set
     */
    public void setCategories(List<String> categories) {
        this.categories = categories;
    }

    /**
     * @return the series
     */
    public List<Map<String, Object>> getSeries() {
        return series;
    }

    /**
     * @param series the series to set
     */
    public void setSeries(List<Map<String, Object>> series) {
        this.series = series;
    }

    /**
     * @return the title
     */
    public String getTitle() {
        return title;
    }

    /**
     * @param title the title to set
     */
    public void setTitle(String title) {
        this.title = title;
    }

    /**
     * @return the subtitle
     */
    public String getSubtitle() {
        return subtitle;
    }

    /**
     * @param subtitle the subtitle to set
     */
    public void setSubtitle(String subtitle) {
        this.subtitle = subtitle;
    }

    /**
     * @return the titleForYAxis
     */
    public String getTitleForYAxis() {
        return titleForYAxis;
    }

    /**
     * @param titleForYAxis the titleForYAxis to set
     */
    public void setTitleForYAxis(String titleForYAxis) {
        this.titleForYAxis = titleForYAxis;
    }
    
}
