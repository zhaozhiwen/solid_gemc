// refer to http://hallaweb.jlab.org/12GeV/SoLID/download/sim/talk/solid_SIDIS_background_zwzhao_20131118.pdf
// FAEC MIP trigger cut on 200MeV curve on slide 14

double forward_hadron_trigger_low_P[29]={0.0265,	0.0595,	0.0925,	0.1255,	0.1585,	0.1915,	0.2245,	0.2575,	0.2905,	0.3235,	0.3565,	0.3895,	0.4225,	0.4555,	0.4885,	0.5215,	0.5545,	0.5875,	0.6205,	0.6535,	0.6865,	0.7195,	0.7525,	0.7855,	0.8185,	0.8515,	0.8845,	0.9175,	0.9505};

double forward_hadron_trigger_high_P[29]={0.0595,	0.0925,	0.1255,	0.1585,	0.1915,	0.2245,	0.2575,	0.2905,	0.3235,	0.3565,	0.3895,	0.4225,	0.4555,	0.4885,	0.5215,	0.5545,	0.5875,	0.6205,	0.6535,	0.6865,	0.7195,	0.7525,	0.7855,	0.8185,	0.8515,	0.8845,	0.9175,	0.9505,	0.9835};


//electron efficiency
double forward_hadron_trigger_e_low_eff[29]={0,	0,	0,	0,	0.00831313,	0.0833676,	0.369744,	0.774367,	0.933252,	0.988943,	0.998504,	1,	0.999131,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	0.998233,	1,	1,	1,	1};

double forward_hadron_trigger_e_high_eff[29]={0,	0,	0,	0.00831313,	0.0833676,	0.369744,	0.774367,	0.933252,	0.988943,	0.998504,	1,	0.999131,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	0.998233,	1,	1,	1,	1,	1};


//gamma efficiency
double forward_hadron_trigger_gamma_low_eff[29]={0,	0,	0.000195771,	0.000525762,	0.0196078,	0.214712,	0.61692,	0.867033,	0.968889,	0.993653,	0.996963,	0.995766,	0.999102,	1,	1,	1,	1,	1,	0.99866,	0.998567,	1,	1,	1,	1,	0.998305,	1,	1,	0.998106,	1};

double forward_hadron_trigger_gamma_high_eff[29]={0,	0.000195771,	0.000525762,	0.0196078,	0.214712,	0.61692,	0.867033,	0.968889,	0.993653,	0.996963,	0.995766,	0.999102,	1,	1,	1,	1,	1,	0.99866,	0.998567,	1,	1,	1,	1,	0.998305,	1,	1,	0.998106,	1,	1};


//pion efficiency
double forward_hadron_trigger_pion_low_eff[29]={0.0193918,	0.419003,	0.598157,	0.743008,	0.808838,	0.857615,	0.87741,	0.910832,	0.925447,	0.945196,	0.958666,	0.956376,	0.953532,	0.962371,	0.970134,	0.965402,	0.98063,	0.979721,	0.979194,	0.986357,	0.990798,	0.990385,	0.991909,	0.988599,	0.991364,	0.990619,	0.990991,	0.994208,	0.996094};

double forward_hadron_trigger_pion_high_eff[29]={0.419003,	0.598157,	0.743008,	0.808838,	0.857615,	0.87741,	0.910832,	0.925447,	0.945196,	0.958666,	0.956376,	0.953532,	0.962371,	0.970134,	0.965402,	0.98063,	0.979721,	0.979194,	0.986357,	0.990798,	0.990385,	0.991909,	0.988599,	0.991364,	0.990619,	0.990991,	0.994208,	0.996094,	0.997921};


//proton efficiency
double forward_hadron_trigger_proton_low_eff[29]={0,	0,	0.00153139,	0.0259336,	0.470748,	0.899351,	0.917235,	0.931217,	0.934783,	0.962238,	0.952522,	0.955738,	0.968284,	0.979821,	0.977629,	0.992788,	0.976744,	0.992683,	0.979228,	0.987562,	0.994118,	0.990937,	0.993976,	0.996599,	1,	1,	0.992674,	1,	0.995984};

double forward_hadron_trigger_proton_high_eff[29]={0,	0.00153139,	0.0259336,	0.470748,	0.899351,	0.917235,	0.931217,	0.934783,	0.962238,	0.952522,	0.955738,	0.968284,	0.979821,	0.977629,	0.992788,	0.976744,	0.992683,	0.979228,	0.987562,	0.994118,	0.990937,	0.993976,	0.996599,	1,	1,	0.992674,	1,	0.995984,	1};




//calculate electron efficiency
double get_forward_hadron_trigger_e_eff(double hit_E){
	double e_eff=0;
	
	if(hit_E<forward_hadron_trigger_low_P[0]){
		e_eff=0;
	}else{

		int P_index=-1;

		for(int Pi=0; Pi<29; Pi++){

			if(hit_E>=forward_hadron_trigger_low_P[Pi] && hit_E<forward_hadron_trigger_high_P[Pi]){
				P_index=Pi;
			}
	
		}

		if(hit_E>=forward_hadron_trigger_high_P[28]){
			P_index=28;
		}

		e_eff=(forward_hadron_trigger_e_high_eff[P_index] - forward_hadron_trigger_e_low_eff[P_index])/( forward_hadron_trigger_high_P[P_index] - forward_hadron_trigger_low_P[P_index] ) * (hit_E - forward_hadron_trigger_low_P[P_index]) + forward_hadron_trigger_e_low_eff[P_index];
	}

	return e_eff;
}


//calculate gamma efficiency
double get_forward_hadron_trigger_gamma_eff(double hit_E){
	double gamma_eff=0;
	
	if(hit_E<forward_hadron_trigger_low_P[0]){
		gamma_eff=0;
	}else{

		int P_index=-1;

		for(int Pi=0; Pi<29; Pi++){

			if(hit_E>=forward_hadron_trigger_low_P[Pi] && hit_E<forward_hadron_trigger_high_P[Pi]){
				P_index=Pi;
			}
	
		}

		if(hit_E>=forward_hadron_trigger_high_P[28]){
			P_index=28;
		}

		gamma_eff=(forward_hadron_trigger_gamma_high_eff[P_index] - forward_hadron_trigger_gamma_low_eff[P_index])/( forward_hadron_trigger_high_P[P_index] - forward_hadron_trigger_low_P[P_index] ) * (hit_E - forward_hadron_trigger_low_P[P_index]) + forward_hadron_trigger_gamma_low_eff[P_index];
	}

	return gamma_eff;
}


//calculate pion efficiency
double get_forward_hadron_trigger_pion_eff(double hit_E){
	double pion_eff=0;
	
	if(hit_E<forward_hadron_trigger_low_P[0]){
		pion_eff=0;
	}else{

		int P_index=-1;

		for(int Pi=0; Pi<29; Pi++){

			if(hit_E>=forward_hadron_trigger_low_P[Pi] && hit_E<forward_hadron_trigger_high_P[Pi]){
				P_index=Pi;
			}
	
		}

		if(hit_E>=forward_hadron_trigger_high_P[28]){
			P_index=28;
		}

		pion_eff=(forward_hadron_trigger_pion_high_eff[P_index] - forward_hadron_trigger_pion_low_eff[P_index])/( forward_hadron_trigger_high_P[P_index] - forward_hadron_trigger_low_P[P_index] ) * (hit_E - forward_hadron_trigger_low_P[P_index]) + forward_hadron_trigger_pion_low_eff[P_index];
	}

	return pion_eff;
}



//calculate proton efficiency
double get_forward_hadron_trigger_proton_eff(double hit_E){
	double proton_eff=0;
	
	if(hit_E<forward_hadron_trigger_low_P[0]){
		proton_eff=0;
	}else{

		int P_index=-1;

		for(int Pi=0; Pi<29; Pi++){

			if(hit_E>=forward_hadron_trigger_low_P[Pi] && hit_E<forward_hadron_trigger_high_P[Pi]){
				P_index=Pi;
			}
	
		}

		if(hit_E>=forward_hadron_trigger_high_P[28]){
			P_index=28;
		}

		proton_eff=(forward_hadron_trigger_proton_high_eff[P_index] - forward_hadron_trigger_proton_low_eff[P_index])/( forward_hadron_trigger_high_P[P_index] - forward_hadron_trigger_low_P[P_index] ) * (hit_E - forward_hadron_trigger_low_P[P_index]) + forward_hadron_trigger_proton_low_eff[P_index];
	}

	return proton_eff;
}

