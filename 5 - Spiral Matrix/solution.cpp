class Solution{

	public:
	int findK(vector<vector<int>> &a, int n, int m, int k)
    {   int count=1;
        int tl=0,tr=m,br=n,bl=0;
        while(count<=m*n){
            for(int i=tl;i<tr;i++){
                if(count==k)
                return a[tl][i];
                count++;
            }
            tl++;
            for(int i=tl;i<br;i++){
                if(count==k)
                return a[i][tr-1];
                count++;
            }
            tr--;
            for(int i=tr-1;i>=bl;i--){
                if(count==k)
                return a[br-1][i];
                count++;
            }
            br--;
            for(int i=br-1;i>=tl;i--){
                if(count==k)
                return a[i][bl];
                count++;
            }
            bl++;
        }
    }

};