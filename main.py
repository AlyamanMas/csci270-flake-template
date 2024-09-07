import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.preprocessing import MinMaxScaler


def euclidean_distance(vec1, vec2):
    distance = 0
    for i in range(len(vec1)):
        distance += (vec1[i] - vec2[i]) ** 2
    return np.sqrt(distance)


columns = [
    "MedInc",
    "HouseAge",
    "AveRooms",
    "AveBedrms",
    "Population",
    "AveOccup",
    "Latitude",
    "Longitude",
]

data = pd.read_csv("./cal_housing.data", header=None, names=columns)

normalized_data = MinMaxScaler().fit_transform(data)

# print(normalized_data)

np.random.seed(42)
random_idx = np.random.randint(0, len(normalized_data))
random_house = normalized_data[random_idx]

manual_house = normalized_data[0]

# distance = euclidean_distance(
#    [manual_house[6], manual_house[7]],
#    [random_house[6], random_house[7]],
# )
#
# print(distance)

eu_dis = euclidean_distance(random_house, manual_house)

feature_labels_for_plot = columns

plt.figure(figsize=(10, 6))
plt.plot(feature_labels_for_plot, manual_house, marker="o", label="Selected House")
plt.plot(feature_labels_for_plot, random_house, marker="x", label="Random House")
plt.title("Call House Normalized Features")
plt.xlabel("Features")
plt.ylabel("Normalized Values")
plt.xticks(rotation=45, ha="right")
plt.grid(True)
plt.tight_layout()

plt.show()
