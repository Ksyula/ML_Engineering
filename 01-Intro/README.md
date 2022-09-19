# Intro Session : Homework & Dataset

Session Overview :

* 1.1 Introduction to Machine Learning
* 1.2 ML vs Rule-Based Systems
* 1.3 Supervised Machine Learning
* 1.4 CRISP-DM
* 1.5 The Modelling Step (Model Selection Process)
* 1.6 Setting up the Environment
* 1.7 Introduction to NumPy
* 1.8 Linear Algebra Refresher
* 1.9 Introduction to Pandas

---------

## Session #1 Homework [link](https://github.com/alexeygrigorev/mlbookcamp-code/blob/master/course-zoomcamp/cohorts/2022/01-intro/homework.md)

### Set up the environment

You need to install Python, NumPy, Pandas, Matplotlib and Seaborn.

### Question 1

What's the version of NumPy that you installed? 

You can get the version information using the `__version__` field:

```python
np.__version__
```

### Getting the data 

For this homework, we'll use the Car price dataset. Download it from 
[here](https://raw.githubusercontent.com/alexeygrigorev/mlbookcamp-code/master/chapter-02-car-price/data.csv).

You can do it with wget:

```bash
wget https://raw.githubusercontent.com/alexeygrigorev/mlbookcamp-code/master/chapter-02-car-price/data.csv
```

Or just open it with your browser and click "Save as...".

Now read it with Pandas.

### Question 2

How many records are in the dataset?

Here you need to specify the number of rows.

- 16
- 6572
- 11914
- 18990

### Question 3

Who are the most frequent car manufacturers (top-3) according to the dataset?

- Chevrolet, Volkswagen, Toyota
- Chevrolet, Ford, Toyota
- Ford, Volkswagen, Toyota
- Chevrolet, Ford, Volkswagen

> **Note**: You should rely on "Make" column in this question.

### Question 4

What's the number of unique Audi car models in the dataset?

- 3
- 16
- 26
- 34

### Question 5

How many columns in the dataset have missing values?

- 5
- 6
- 7
- 8

### Question 6

1. Find the median value of "Engine Cylinders" column in the dataset.
2. Next, calculate the most frequent value of the same "Engine Cylinders".
3. Use the `fillna` method to fill the missing values in "Engine Cylinders" with the most frequent value from the previous step.
4. Now, calculate the median value of "Engine Cylinders" once again.

Has it changed?

> Hint: refer to existing `mode` and `median` functions to complete the task.

- Yes
- No

### Question 7

1. Select all the "Lotus" cars from the dataset.
2. Select only columns "Engine HP", "Engine Cylinders".
3. Now drop all duplicated rows using `drop_duplicates` method (you should get a dataframe with 9 rows).
4. Get the underlying NumPy array. Let's call it `X`.
5. Compute matrix-matrix multiplication between the transpose of `X` and `X`. To get the transpose, use `X.T`. Let's call the result `XTX`.
6. Invert `XTX`.
7. Create an array `y` with values `[1100, 800, 750, 850, 1300, 1000, 1000, 1300, 800]`.
8. Multiply the inverse of `XTX` with the transpose of `X`, and then multiply the result by `y`. Call the result `w`.
9. What's the value of the first element of `w`?

> **Note**: You just implemented linear regression. We'll talk about it in the next lesson.

- -0.0723
- 4.5949
- 31.6537
- 63.5643


## Submit the results

Submit your results here: https://forms.gle/vLp3mvtnrjJxCZx66

If your answer doesn't match options exactly, select the closest one.


## Deadline

The deadline for submitting is 12 September 2022 (Monday), 23:00 CEST (Berlin time).

After that, the form will be closed.
