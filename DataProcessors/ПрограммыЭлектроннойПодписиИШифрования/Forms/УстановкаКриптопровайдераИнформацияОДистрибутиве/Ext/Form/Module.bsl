﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("КонтрольнаяСумма", КонтрольнаяСумма);
	Параметры.Свойство("Дистрибутив", Дистрибутив);
	Параметры.Свойство("Версия", Версия);
	Параметры.Свойство("ИмяПрограммы", ИмяПрограммы);
	
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Установка %1'"), ИмяПрограммы);
	Элементы.ДекорацияДистрибутивЗагружен.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Дистрибутив %1 успешно загружен и готов к установке.'"), ИмяПрограммы);
	Элементы.Дистрибутив.Подсказка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Версия: %1'"), Версия);
	
	Если ИмяПрограммы = ЭлектроннаяПодписьКлиентСерверЛокализация.ИмяПрограммыVipNet() Тогда
		Элементы.КонтрольнаяСуммаРасширеннаяПодсказка.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(НСтр("ru = 'Контрольную сумму можно проверить с помощью приложения ViPNet HashCalc.
		|Его можно скачать с сайта <a href = www.infotecs.ru>www.infotecs.ru</a>.'"));
	Иначе
		Элементы.КонтрольнаяСуммаРасширеннаяПодсказка.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(НСтр("ru = 'Контрольную сумму можно проверить с помощью приложения cpverify.exe.
		|Его можно скачать с сайта <a href = www.cryptopro.ru>www.cryptopro.ru</a>.'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Установить(Команда)
	
	Закрыть(Истина);
	
КонецПроцедуры

#КонецОбласти