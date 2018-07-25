using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SceneChange : MonoBehaviour 
{

    public GameObject m_Scene1;
    public GameObject m_Scene2;


    void OnGUI()
    {
        if (!m_Scene1 || !m_Scene2)
            return;

        if (GUI.Button(new Rect(10, 10, 100, 50), "Exit"))
        {
            Application.Quit();
        }

        if (GUI.Button(new Rect(10, 100, 100, 50), "Change Scene")){
            if(m_Scene1.activeSelf){
                m_Scene1.SetActive(false);
                m_Scene2.SetActive(true);
            }
            else if (m_Scene2.activeSelf)
            {
                m_Scene1.SetActive(true);
                m_Scene2.SetActive(false);
            }
        }
    }
}
