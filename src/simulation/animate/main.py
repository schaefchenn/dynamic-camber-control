import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation, FFMpegWriter
from matplotlib.lines import Line2D

dataName = "deccel_from80.csv"
animationName = "deccel_from80_graph.mp4"

# Read CSV
df = pd.read_csv(dataName)
print(df.shape)
print(df.head())

# Convert pixels to inches for figsize (matplotlib default DPI=100)
dpi = 100
width_in = 1920 / dpi
height_in = (1080/4) / dpi

# Plot setup with custom background color
fig, ax = plt.subplots(figsize=(width_in, height_in), dpi=dpi)
fig.patch.set_facecolor('#222222')
ax.set_facecolor('#222222')

ax.tick_params(axis='x', colors='white')  # X-Achse Zahlenfarbe
ax.tick_params(axis='y', colors='white')  # Y-Achse Zahlenfarbe

ax.set_xlabel('', color='white')
ax.set_ylabel('', color='white')

ax.grid(True, color='gray', alpha=0.5)

ax.set_xlim(df['time'].min(), df['time'].max())
y_min = min(df['camberFL'].min(), df['cmCamKinFL'].min(), df['camberFR'].min(), df['cmCamKinFR'].min())
y_max = max(df['camberFL'].max(), df['cmCamKinFL'].max(), df['camberFR'].max(), df['cmCamKinFR'].max())
ax.set_ylim(y_min*1.1, y_max*1.1)

# Remove axes spines
for spine in ax.spines.values():
    spine.set_visible(True)
    spine.set_color('white')

# Define four lines
line_FL, = ax.plot([], [], color='#49BFBF', linestyle='-', label='sim camber FL (rad)')
line_FL2, = ax.plot([], [], color='#49BFBF', linestyle='--', label='cm camber FL (rad)')
line_FR, = ax.plot([], [], color='#F2C12E', linestyle='-', label='sim camber FR (rad)')
line_FR2, = ax.plot([], [], color='#F2C12E', linestyle='--', label='cm camber FR (rad)')

ax.set_xlabel('time (s)', color='white', labelpad=15)

custom_legend = [
    Line2D([0], [0], linestyle='-', color='#49BFBF', markerfacecolor='#49BFBF', markersize=10, label='sim camber FL (rad)'),
    Line2D([0], [0], linestyle='--', color='#49BFBF', markerfacecolor='#49BFBF', markersize=10, label='cm camber FL (rad)'),
    Line2D([0], [0], linestyle='-', color='#F2C12E', markerfacecolor='#F2C12E', markersize=10, label='sim camber FR (rad)'),
    Line2D([0], [0], linestyle='--', color='#F2C12E', markerfacecolor='#F2C12E', markersize=10, label='cm camber FR (rad)')
]

ax.legend(
    handles=custom_legend,
    loc='upper right',
    bbox_to_anchor=(1, 1.10),
    frameon=False,
    labelcolor='white'
)

# Buffers
x_data = []
y = []
y2 = []
y3 = []
y4 = []

window_size = 3
look_ahead = 1.5 
# Update function
def update(frame):
    t = df.loc[frame, 'time']
    x_data.append(t)
    y.append(df.loc[frame, 'camberFL'])
    y2.append(df.loc[frame, 'cmCamKinFL'])
    y3.append(df.loc[frame, 'camberFR'])
    y4.append(df.loc[frame, 'cmCamKinFR'])

    line_FL.set_data(x_data, y)
    line_FL2.set_data(x_data, y2)
    line_FR.set_data(x_data, y3)
    line_FR2.set_data(x_data, y4)

    if frame == 0:
        ax.set_xlim(df['time'].min(), df['time'].min() + window_size + look_ahead)
    else:
        x_min = max(t - window_size, df['time'].min())
        x_max = t + look_ahead
        ax.set_xlim(x_min, x_max)

    return line_FL, line_FL2, line_FR, line_FR2

for spine in ax.spines.values():
    spine.set_visible(False)

# Animation setup
ani = FuncAnimation(fig, update, frames=len(df), blit=False, interval=10)

# Save animation
writer = FFMpegWriter(fps=100)
ani.save(animationName, writer=writer)