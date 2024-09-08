﻿
#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОчиститьИсториюОбмена(Команда)
	ТекстВопроса = НСтр("ru = 'История обмена данными с сервисом прогнозирования будет удалена. Продолжить?'");
	Оповещение = Новый ОписаниеОповещения("ОчиститьИсториюОбменаЗавершение", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьИсториюОбменаЗавершение(Результат, ПараметрКоманды) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьИсториюОбменаНаСервере();
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьИсториюОбменаНаСервере()
	
	Набор = РегистрыСведений.ЖурналСервисаПрогнозирования.СоздатьНаборЗаписей();
	Набор.Записать();
	
КонецПроцедуры

#КонецОбласти