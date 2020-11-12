
# The Simple Yet Practical Data Cleaning Codes - by Admond Lee https://towardsdatascience.com/the-simple-yet-practical-data-cleaning-codes-ad27c4ce0a38

##1 Drop multiple columns

def drop_multiple_col(col_names_list, df):
    '''
    AIM     -> Drop multiple columns based on their column names
    INPUT   -> List of column names, df
    OUTPUT  -> Updated df with dropped columns
    --------
    '''

    df.drop(col_names_list, axis=1, inplace=True)
    return df

##2 Change dtypes

def change_dtypes(col_int, col_float, df)
    '''
    AIM     -> Change dtypes to save memory
    INPUT   -> List of column names(int, float), df
    OUTPUT  -> Updated df with smaller memory
    ------
    '''
    df[col_int] = df[col_int].astype('int32')
    df[col_float] = df[col_float].astype('float32')
    

##3 Convert categorical variable to numerical variable

def convert_cat2num(df):
    # Convert categorical variable to numerical variable

    num_encode = {'col_1' : {'Yes':1, 'No':0},
                  'col_2':{'WON':1, 'LOSE':0, 'DRAW':0}}

    df.replace(num_encode, inplace=True)
    

##4 Checking missing data

def check_missing_data(df):
    # check for any missing data in the df(disaply in descending order)

    return df.isnull().sum().sort_values(ascending=False)

##5 Removing strings in columns

def remove_col_str(df)
    # remove a portion of string in a data frame column - col_1

    df['col_1'].replace('\n', '', regex=True, inplace=True)

    #remove all the characters after &#(including &#) for column - col_1

    df['col_1'].replace(' &#.*', '', regex=True, inplace=True)


##6 remove white space in columns

def remove_col_with_space(df, col):
    # remove white space at the begining of string

    df[col] = df[col].str.lstrip()


##7 Concatennate two columns with string(with condtion)

def concat_str_condtion(df)
    # concat 2 columns with strings if the last 3 letters of the first colun art 'pil'

    mask = df['col_1'].str.endswith('pil', na=False)
    col_new = df[mask]['col_1'] + df[mask]['col_2']
    col_new.replace('pil', ' ', regex=True, inplace=True) # replace the 'pil' with empty space

##8 Convert timestamp(from string to datetime format)

def convert_str_datetime(df):
    '''
    AIM     -> Convert datastamps(string) to datetime(format we want)
    INPUT   -> df
    output  -> Updated df with new datetime format
    --------
    '''
    df.insert(loc=2, column='timestamp', value=pd.to_datetime(df.transdate, format'%Y-%m-%d %H:%M:%S.%f'))

