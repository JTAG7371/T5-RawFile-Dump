
#undef CHOICE_SEP_CALC_SPACING
#undef CHOICE_SEP_CALC_SPACING_1
#undef CHOICE_SEP_CALC_SPACING_2
#undef CHOICE_SEP_CALC_SPACING_3
#undef CHOICE_SEP_CALC_SPACING_4

#define CHOICE_SEP_CALC_SPACING( itemIndex, sepIndex, sepSpacingNext, sepSpacingPrev ) \
	((itemIndex > sepIndex) ? sepSpacingNext : sepSpacingPrev)

#define CHOICE_SEP_CALC_SPACING_1( itemIndex ) \
	CHOICE_SEP_CALC_SPACING( itemIndex, CHOICE_SEP_1, CHOICE_SEP_SPACING, 0 )

#define CHOICE_SEP_CALC_SPACING_2( itemIndex ) \
	CHOICE_SEP_CALC_SPACING( itemIndex, CHOICE_SEP_2, CHOICE_SEP_SPACING*2, CHOICE_SEP_CALC_SPACING_1( itemIndex ) )

#define CHOICE_SEP_CALC_SPACING_3( itemIndex ) \
	CHOICE_SEP_CALC_SPACING( itemIndex, CHOICE_SEP_3, CHOICE_SEP_SPACING*3, CHOICE_SEP_CALC_SPACING_2( itemIndex ) )

#define CHOICE_SEP_CALC_SPACING_4( itemIndex ) \
	CHOICE_SEP_CALC_SPACING( itemIndex, CHOICE_SEP_4, CHOICE_SEP_SPACING*4, CHOICE_SEP_CALC_SPACING_3( itemIndex ) )

#undef CHOICE_SEP_TOTAL_SPACING

#if !defined( CHOICE_SEP_1 ) || !defined( CHOICE_SEP_SPACING )
#define CHOICE_SEP_TOTAL_SPACING( itemIndex )	0
#elif !defined( CHOICE_SEP_2 )
#define CHOICE_SEP_TOTAL_SPACING( itemIndex )	CHOICE_SEP_CALC_SPACING_1( itemIndex )
#elif !defined( CHOICE_SEP_3 )
#define CHOICE_SEP_TOTAL_SPACING( itemIndex )	CHOICE_SEP_CALC_SPACING_2( itemIndex )
#elif !defined( CHOICE_SEP_4 )
#define CHOICE_SEP_TOTAL_SPACING( itemIndex )	CHOICE_SEP_CALC_SPACING_3( itemIndex )
#else
#define CHOICE_SEP_TOTAL_SPACING( itemIndex )	CHOICE_SEP_CALC_SPACING_4( itemIndex )
#endif
