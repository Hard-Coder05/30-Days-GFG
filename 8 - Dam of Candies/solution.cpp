class Solution{
    
    public:
    int max(int a, int b)
    {
    if(a>=b) return a;
    return b;
    }
    int min(int a, int b)
    {
    if(a<=b) return a;
    return b;
    }
    int maxCandy(int height[], int n) 
    { 
        int ans=0;
        if(n<3) return 0;
        int l=0,r=n-1;
        while(l<r){
            ans=max(ans,min(height[l],height[r])*(r-l-1));
            if(height[l]<height[r])
            l++;
            else
            r--;
        }
        return ans;
    }   
};