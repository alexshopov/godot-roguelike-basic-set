using Godot;

/// <summary>
/// Handle camera movement
/// </summary>
public partial class CameraRig : Node3D {
	/// <summary>
	/// Camera pan speed multiplier. Scales based on zoom level.
	/// </summary>
	[Export]
	private float cameraPanSpeed = 0.125f;

	private Camera3D camera;

	/// <summary>
	/// Called when the CameraRig enters the scene tree. Initializes the camera reference.
	/// </summary>
    public override void _Ready() {
		camera = GetNode<Camera3D>("Camera3D");
    }

	/// <summary>
	/// Called once per frame. Handle camera zoom in response to WASD input
	/// </summary>
	/// <param name="delta">Time elapsed since the previous frame.</param>
	public override void _Process(double delta) {
		Vector3 forward = Transform.Basis.Z.Normalized() * cameraPanSpeed;
		Transform3D newTransform = Transform;

		if (Input.IsActionPressed("camera_pan_up"))
			newTransform.Origin -= forward;

		if (Input.IsActionPressed("camera_pan_down"))
			newTransform.Origin += forward;

		if (Input.IsActionPressed("camera_pan_left"))
			newTransform.Origin += forward.Cross(Vector3.Up) * 0.75f;

		if (Input.IsActionPressed("camera_pan_right"))
			newTransform.Origin -= forward.Cross(Vector3.Up) * 0.75f;

		Transform = newTransform;

	}

	/// <summary>
	/// Handle discrete input events. Handle camera zoom in response to mouse scroll
	/// or key presses.
	/// </summary>
	/// <param name="event"></param>
    public override void _Input(InputEvent @event) {
		if (Input.IsActionJustPressed("camera_zoom_out")) {
			if (camera.Size < 30f) {
				camera.Size += 1f;
				cameraPanSpeed = camera.Size / 100f;
			}
		}
		else if (Input.IsActionJustPressed("camera_zoom_in")) {
			if (camera.Size > 3f) {
				camera.Size -= 1f;
				cameraPanSpeed = camera.Size / 100f;
			}
		}
	}
}
