 class Solution{
    
    public:
    int CountPairs(int arr[], int n) 
{   sort(arr, arr + n); 
    int count = 0; 
    int l = 0, r = n - 1; 
    while (l < r) { 
        if (arr[l] + arr[r] > 0) { 
            count += (r - l); 
            r--; 
        } 
        else { 
            l++; 
        } 
    } 
    return count; 
} };