using Godot;
using System;

public partial class GameMap : Node3D
{
    private GridMap _gridMap;

    public override void _Ready()
    {
        _gridMap = GetNode<GridMap>("GridMap");
        _gridMap.CellSize = Vector3.One;
    }

    public void Init(int mapWidth, int mapHeight)
    {
        var meshes = _gridMap.GetMeshes();

        for (int i = -mapWidth / 2; i < mapWidth / 2; ++i)
        {
            for (int j = -mapHeight / 2; j < mapHeight / 2; ++j)
            {
                _gridMap.SetCellItem(new Vector3I(i, -1, j), 0);
            }
        }

        _gridMap.SetCellItem(new Vector3I(2, -1, -2), 1);
        _gridMap.SetCellItem(new Vector3I(3, -1, -2), 1);
        _gridMap.SetCellItem(new Vector3I(4, -1, -2), 1);
    }
}
