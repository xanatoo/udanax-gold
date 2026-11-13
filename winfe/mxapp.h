#ifndef APP_HXX
#define APP_HXX

class FEApplication {
public:
	static FEFormContentTypeP AkordFormType;
	static FEFormContentTypeP AttnFormType;
	static FEFormContentTypeP CProfFormType;
	static FEFormContentTypeP HomeFormType;
	static FEFormContentTypeP MemoFormType;
	static FEFormContentTypeP RateFormType;
	static FEFormContentTypeP TabsFormType;
	static FEFormContentTypeP UMFormType;

	// TODO: should this go elsewhere
	/* bring up a window named by a ref in the home document */
	static void show (XuStringVar);

}

#endif APP_HXX
