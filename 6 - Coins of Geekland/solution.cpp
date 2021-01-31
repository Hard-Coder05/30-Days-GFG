class Solution{
    
    public:
    int Maximum_Sum(vector<vector<int>> &mat,int N,int k){
    int stripSum[N][N]; 
    for (int j=0; j<N; j++) 
    { 
        int sum = 0; 
        for (int i=0; i<k; i++) 
            sum += mat[i][j]; 
        stripSum[0][j] = sum;  
        for (int i=1; i<N-k+1; i++) 
        { 
            sum += (mat[i+k-1][j] - mat[i-1][j]); 
            stripSum[i][j] = sum; 
        } 
    } 
    int max_sum = INT_MIN; 
    for (int i=0; i<N-k+1; i++) 
    { 
        int sum = 0; 
        for (int j = 0; j<k; j++) 
            sum += stripSum[i][j]; 
        if (sum > max_sum) 
        { 
            max_sum = sum;  
        } 
        for (int j=1; j<N-k+1; j++) 
        { 
            sum += (stripSum[i][j+k-1] - stripSum[i][j-1]); 
            if (sum > max_sum) 
            { 
                max_sum = sum; 
            } 
        } 
    }
    return max_sum;
    }  
};