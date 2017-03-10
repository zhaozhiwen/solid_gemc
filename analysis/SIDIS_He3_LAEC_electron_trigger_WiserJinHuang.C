// refer to http://hallaweb.jlab.org/12GeV/SoLID/download/sim/talk/solid_SIDIS_background_zwzhao_20131118.pdf
// FAEC e trigger cut on Q2=1 curve on slide 5
// FAEC e trigger cut R edge 90,105,115,130,150,200,230 cm
// FAEC e trigger cut P value 5,4,3,2,1,2 GeV
// LAEC e trigger cut P>3GeV on slide 3/

//large angle electron trigger curve has only 20 points

double R_min=80.0;   
double R_max=140.0;


double large_electron_trigger_low_P[19]={1.575,	1.725,	1.875,	2.025,	2.175,	2.325,	2.475,	2.625,	2.775,	2.925,	3.075,	3.225,	3.375,	3.525,	3.675,	3.825,	3.975,	4.125,	4.275};
double large_electron_trigger_high_P[19]={1.725,1.875,	2.025,	2.175,	2.325,	2.475,	2.625,	2.775,	2.925,	3.075,	3.225,	3.375,	3.525,	3.675,	3.825,	3.975,	4.125,	4.275,	4.425};


double large_electron_trigger_e_low_eff[19]={0.0131579,	0.00699301,	0.0152672,	0.0214286,	0.030303,	0.0980392,	0.15942,	0.467532,	0.844262,	0.957447,	0.993007,	1,	0.993289,	1,	1,	1,	1,	1,	1};
double large_electron_trigger_e_high_eff[19]={0.00699301,	0.0152672,	0.0214286,	0.030303,	0.0980392,	0.15942,	0.467532,	0.844262,	0.957447,	0.993007,	1,	0.993289,	1,	1,	1,	1,	1,	1,	1};

double large_electron_trigger_pi_low_eff[19]={0.00683761,	0.00340716,	0.0051458,	0.00492611,	0.00344828,	0.00616333,	0.0259965,	0.0127796,	0.0188679,	0.0469799,	0.0626959,	0.0615641,	0.0834725,	0.0875912,	0.114062,	0.148649,	0.186579,	0.17962,	0.193811};
double large_electron_trigger_pi_high_eff[19]={0.00340716,	0.0051458,	0.00492611,	0.00344828,	0.00616333,	0.0259965,	0.0127796,	0.0188679,	0.0469799,	0.0626959,	0.0615641,	0.0834725,	0.0875912,	0.114062,	0.148649,	0.186579,	0.17962,	0.193811,	0.183639};


double get_large_electron_trigger_e_eff(double hit_R, double hit_E){
	
	double e_eff=0;

	if(hit_R<R_min || hit_R>R_max){
		e_eff=0;
	}else{
		int P_index=-1;

	    if(hit_E<large_electron_trigger_low_P[0]){
		e_eff=0;
	    }else{		
		for(int Pj=0;Pj<19;Pj++){
			if(hit_E>=large_electron_trigger_low_P[Pj] && hit_E<large_electron_trigger_high_P[Pj]){
				P_index=Pj;
			}
		}

		if(hit_E>=large_electron_trigger_high_P[18]){
			P_index=18;
		}
		
		//(eff_high-eff_low)/(x_high-x_low)*(hit_E-x_low) + eff_low
		e_eff=(large_electron_trigger_e_high_eff[P_index] - large_electron_trigger_e_low_eff[P_index]  )/( large_electron_trigger_high_P[P_index] -  large_electron_trigger_low_P[P_index]) * (hit_E- large_electron_trigger_low_P[P_index]) + large_electron_trigger_e_low_eff[P_index] ;

		//e_eff=0.5*(large_electron_trigger_e_low_eff[P_index]+large_electron_trigger_e_high_eff[P_index]);
	    }
	}

	return e_eff;
}

double get_large_electron_trigger_pi_eff(double hit_R, double hit_E){
	
	double e_eff=0;

	if(hit_R<R_min || hit_R>R_max){
		e_eff=0;
	}else{
		int P_index=-1;
	    if(hit_E<large_electron_trigger_low_P[0]){
		e_eff=0;
	    }else{	
		for(int Pj=0;Pj<19;Pj++){
			if(hit_E>=large_electron_trigger_low_P[Pj] && hit_E<large_electron_trigger_high_P[Pj]){
				P_index=Pj;
			}
		}

		if(hit_E>=large_electron_trigger_high_P[18]){
			P_index=18;
		}
		//
		 e_eff=(large_electron_trigger_pi_high_eff[P_index] - large_electron_trigger_pi_low_eff[P_index]  )/( large_electron_trigger_high_P[P_index] -  large_electron_trigger_low_P[P_index]) * (hit_E- large_electron_trigger_low_P[P_index]) + large_electron_trigger_pi_low_eff[P_index] ;

		//e_eff=0.5*(large_electron_trigger_pi_low_eff[P_index]+large_electron_trigger_pi_high_eff[P_index]);
	    }
	}

	return e_eff;
}
