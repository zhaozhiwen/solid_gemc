// refer to http://hallaweb.jlab.org/12GeV/SoLID/download/sim/talk/solid_SIDIS_background_zwzhao_20131118.pdf
// FAEC e trigger cut on Q2=1 curve on slide 5
// FAEC e trigger cut R edge 90,105,115,130,150,200,230 cm
// FAEC e trigger cut P value 5,4,3,2,1,2 GeV
// LAEC e trigger cut P>3GeV on slide 3

double forward_electron_trigger_low_R[6]={90,105,115,130,150,200};
double forward_electron_trigger_high_R[6]={105,115,130,150,200,230};


double forward_electron_trigger_low_P[20]={0.833333,	1.16667,	1.5,	1.83333,	2.16667,	2.5,	2.83333,	3.16667,	3.5,	3.83333,	4.16667,	4.5,	4.83333,	5.16667,	5.5,	5.83333,	6.16667,	6.5,	6.83333,    7.16667};

double forward_electron_trigger_high_P[20]={1.16667,	1.5,	1.83333,	2.16667,	2.5,	2.83333,	3.16667,	3.5,	3.83333,	4.16667,	4.5,	4.83333,	5.16667,	5.5,	5.83333,	6.16667,	6.5,	6.83333,    7.16667,	7.5};

double forward_electron_trigger_e_low_eff[6][20]={
{0,	0,	0,	0.00542005,	0,	0,	0.0104167,	0.00244499,	0.00954654,	0.0216216,	0.0230947,	0.077951,	0.718157,	0.988732,	1,	1,	1,	1,	1,	1},
{0,	0,	0,	0.00813008,	0.0027027,	0.00520833,	0.015625,	0.0268949,	0.052506,	0.608108,	0.983834,	1,	1,	1,	1,	1,	1,	1,	1,	1},
{0,	0.00436681,	0.00357143,	0.0189702,	0.0135135,	0.0260417,	0.552083,	0.977995,	0.997613,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1},
{0.0285714,	0.0174672,	0.0392857,	0.704607,	0.997297,	1,	1,	1,	1,	1,	1,  1,	1,	1,	1,	1,	1,	1,	1,	1},
{0.771429,	0.991266,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,  1,	1,	1,	1,	1,	1},
{0.0285714,	0.0174672,	0.0392857,	0.704607,	0.997297,	1,	1,	1,	1,	1,	1,  1,	1,	1,	1,	1,	1,	1,	1,	1}
};

double forward_electron_trigger_e_high_eff[6][20]={
{0,	0,	0.00542005,	0,	0,	0.0104167,	0.00244499,	0.00954654,	0.0216216,	0.0230947,	0.077951,	0.718157,	0.988732,	1,	1,	1,	1,	1,	1,	1},
{0,	0,	0.00813008,	0.0027027,	0.00520833,	0.015625,	0.0268949,	0.052506,	0.608108,	0.983834,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1},
{0.00436681,	0.00357143,	0.0189702,	0.0135135,	0.0260417,	0.552083,	0.977995,	0.997613,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1},
{0.0174672,	0.0392857,	0.704607,	0.997297,	1,	1,	1,	1,	1,	1,  1,	1,	1,	1,	1,	1,	1,	1,	1,	1},
{0.991266,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,  1,	1,	1,	1,	1,	1,	1},
{0.0174672,	0.0392857,	0.704607,	0.997297,	1,	1,	1,	1,	1,	1,  1,	1,	1,	1,	1,	1,	1,	1,	1,	1}
};

double forward_electron_trigger_pi_low_eff[6][20]={
{0,	0,	0.00319744,	0.00187149,	0.0019685,	0,	0.00179533,	0.00243309,	0.00233781,	0.000604595,	0.00117716,	0.00435256,	0.00392413,	0.0144563,	0.0289126,	0.0333124,	0.049435,	0.0793037,	0.0993337,	0.119795},
{0,	0,	0.00319744,	0.00187149,	0.00262467,	0.00127389,	0.00777977,	0.00304136,	0.00350672, 0.00906892,	0.0206004,	0.0293798,	0.0457816,	0.0741672,	0.103708,	0.127593,	0.174435,   0.1902,	0.223501,	0.250428},
{0,	0,	0.00319744,	0.00311915,	0.00459318,	0.00509554,	0.0167564,	0.0273723,	0.0555231,  0.0973398,	0.135374,	0.171382,	0.214519,	0.22313,	0.277184,	0.280955,	0.319915,   0.319149,	0.353725,	0.378779},
{0.0097561,	0.00610998,	0.0151878,	0.0536494,	0.105643,	0.161146,	0.239976,	0.298054,   0.329047,	0.374849,	0.373161,	0.396083,	0.42119,	0.404777,	0.434947,	0.416719,   0.466102,	0.449387,	0.466384,	0.478608},
{0.102439,	0.195519,	0.319744,	0.411728,	0.456037,	0.475159,	0.51167,	0.532847,   0.528346,	0.539299,	0.535609,	0.537541,	0.551995,	0.516656,	0.526084,	0.512885,   0.560028,	0.529336,	0.545124,	0.554478},
{0.0097561,	0.00610998,	0.0151878,	0.0536494,	0.105643,	0.161146,	0.239976,	0.298054,   0.329047,	0.374849,	0.373161,	0.396083,	0.42119,	0.404777,	0.434947,	0.416719,   0.466102,	0.449387,	0.466384,	0.478608}
};

double forward_electron_trigger_pi_high_eff[6][20]={
{0,	0.00319744,	0.00187149,	0.0019685,	0,	0.00179533,	0.00243309,	0.00233781,	0.000604595,	0.00117716,	0.00435256,	0.00392413,	0.0144563,	0.0289126,	0.0333124,	0.049435,	0.0793037,	0.0993337,	0.119795,	0.153956},
{0,	0.00319744,	0.00187149,	0.00262467,	0.00127389,	0.00777977,	0.00304136,	0.00350672, 0.00906892,	0.0206004,	0.0293798,	0.0457816,	0.0741672,	0.103708,	0.127593,	0.174435,   0.1902,	0.223501,	0.250428,	0.282252},
{0,	0.00319744,	0.00311915,	0.00459318,	0.00509554,	0.0167564,	0.0273723,	0.0555231,  0.0973398,	0.135374,	0.171382,	0.214519,	0.22313,	0.277184,	0.280955,	0.319915,   0.319149,	0.353725,	0.378779,	0.379187},
{0.00610998,	0.0151878,	0.0536494,	0.105643,	0.161146,	0.239976,	0.298054,   0.329047,	0.374849,	0.373161,	0.396083,	0.42119,	0.404777,	0.434947,	0.416719,   0.466102,	0.449387,	0.466384,	0.478608,	0.494654},
{0.195519,	0.319744,	0.411728,	0.456037,	0.475159,	0.51167,	0.532847,   0.528346,	0.539299,	0.535609,	0.537541,	0.551995,	0.516656,	0.526084,	0.512885,   0.560028,	0.529336,	0.545124,	0.554478,	0.55809},
{0.00610998,	0.0151878,	0.0536494,	0.105643,	0.161146,	0.239976,	0.298054,   0.329047,	0.374849,	0.373161,	0.396083,	0.42119,	0.404777,	0.434947,	0.416719,   0.466102,	0.449387,	0.466384,	0.478608,	0.494654}
};



double get_forward_electron_trigger_e_eff(double hit_R, double hit_E){
	double e_eff=0; //return value

	int R_index=-1;
	int P_index=-1;
	
	if(hit_R<forward_electron_trigger_low_R[0] || hit_R>forward_electron_trigger_high_R[5]){
		e_eff=0;
	}else{
		//get R_index
		for(int Ri=0;Ri<6;Ri++){
			if(hit_R>=forward_electron_trigger_low_R[Ri] && hit_R<forward_electron_trigger_high_R[Ri]){
				R_index=Ri;
			}
		}
		//cout<<" R index: "<<R_index<<endl;

		if(hit_E<forward_electron_trigger_low_P[0]){
			e_eff=0;
		}else{
			//get P index
			
			for(int Pj=0;Pj<=19;Pj++){
				if(hit_E>=forward_electron_trigger_low_P[Pj] && hit_E<forward_electron_trigger_high_P[Pj]){
					P_index=Pj;
				}
			}

			if(hit_E>=forward_electron_trigger_high_P[19]){
				P_index=19;
			}

			//cout<<" P index: "<<P_index<<endl;
		
			//now get R_index and P_index

			//e_eff=0.5*(forward_electron_trigger_e_low_eff[R_index][P_index]+forward_electron_trigger_e_high_eff[R_index][P_index] );
			 e_eff=(forward_electron_trigger_e_high_eff[R_index][P_index] - forward_electron_trigger_e_low_eff[R_index][P_index]  )/( forward_electron_trigger_high_P[P_index] -  forward_electron_trigger_low_P[P_index]) * (hit_E- forward_electron_trigger_low_P[P_index]) + forward_electron_trigger_e_low_eff[R_index][P_index] ;
		
		}
	}
	return e_eff;
}
		
double get_forward_electron_trigger_pi_eff(double hit_R, double hit_E){
	double e_eff=0; //return value

	int R_index=-1;
	int P_index=-1;
	if(hit_R<forward_electron_trigger_low_R[0] || hit_R>forward_electron_trigger_high_R[5]){
		e_eff=0;
	}else{
		//get R_index
		for(int Ri=0;Ri<6;Ri++){
			if(hit_R>=forward_electron_trigger_low_R[Ri] && hit_R<forward_electron_trigger_high_R[Ri]){
				R_index=Ri;
			}
		}

		if(hit_E<forward_electron_trigger_low_P[0]){
			e_eff=0;
		}else{
			//get P index
			
			for(int Pj=0;Pj<=19;Pj++){
				if(hit_E>=forward_electron_trigger_low_P[Pj] && hit_E<forward_electron_trigger_high_P[Pj]){
					P_index=Pj;
				}
			}

			if(hit_E>=forward_electron_trigger_high_P[19]){
				P_index=19;
			}
		
			//now get R_index and P_index

			//e_eff=0.5*(forward_electron_trigger_pi_low_eff[R_index][P_index]+forward_electron_trigger_pi_high_eff[R_index][P_index] );
			 e_eff=(forward_electron_trigger_pi_high_eff[R_index][P_index] - forward_electron_trigger_pi_low_eff[R_index][P_index]  )/( forward_electron_trigger_high_P[P_index] -  forward_electron_trigger_low_P[P_index]) * (hit_E- forward_electron_trigger_low_P[P_index]) + forward_electron_trigger_pi_low_eff[R_index][P_index] ;
		
		}
	}
	return e_eff;
}
		
