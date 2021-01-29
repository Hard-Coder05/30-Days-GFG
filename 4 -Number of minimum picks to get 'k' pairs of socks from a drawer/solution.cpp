class Solution{

	public:
	int find_min(int a[], int n, int k) {
	    int maxpair=0,sum = 0;
	    for(int i=0;i<n;i++){
	        maxpair+=a[i]/2;
	        if (a[i] % 2 == 0)
            sum += (a[i] - 2) / 2;
            else
            sum += (a[i] - 1) / 2;
	    }
        if(maxpair<k)
        return -1;
        if (k <= sum) return 2 * (k - 1) + n + 1;
        return 2 * sum + n + (k - sum);
    }
};